#! /usr/bin/env python
#
# This tool is provided by dblatex (http://dblatex.sourceforge.net) and has
# the same copyright.
#
# It was initially developped to find out the fonts used and their size because
# as strange as it may seem, no obvious tool gives the font sizes used (pdffonts
# just lists the font objects of the PDF). The script can be improved to give
# more informations in a next release.
#
# To understand the PDF format, read:
#   * The reference:
#     http://www.adobe.com/content/dam/Adobe/en/devnet/acrobat/pdfs/
#                                                      pdf_reference_1-7.pdf
#
#   * A usefull introduction:
#     http://www.adobe.com/content/dam/Adobe/en/technology/pdfs/
#                                                      PDF_Day_A_Look_Inside.pdf
#
#
import os
import sys
import traceback
import zlib
import re
import logging
import tempfile
import shutil
import struct
import codecs


class ErrorHandler:
    def __init__(self):
        self._dump_stack = False
        self.rc = 0

    def dump_stack(self, dump=True):
        self._dump_stack = dump

    def failure_track(self, msg, rc=1):
        self.rc = rc
        print >>sys.stderr, (msg)
        if self._dump_stack:
            traceback.print_exc()

    def failed_exit(self, rc=1):
        self.failure_track(msg, rc)
        sys.exit(self.rc)

def pdfstring_is_list(data):
    return (data and data[0] == "[" and data[-1] == "]")


class PDFResolver:
    _resolver = None

    @classmethod
    def set_resolver(cls, resolver):
        cls._resolver = resolver

    @classmethod
    def get_resolver(cls):
        return cls._resolver


class PDFBaseObject:
    _log = logging.getLogger("pdfscan.base")

    def __init__(self):
        pass
    def debug(self, text):
        self._log.debug(text)
    def warning(self, text):
        self._log.warning(text)
    def error(self, text):
        self._log.error(text)
    def info(self, text):
        self._log.info(text)


class PDFFile(PDFBaseObject):
    """
    Main object that parses the PDF file and extract the objects needed for
    scanning.
    """
    _log = logging.getLogger("pdfscan.pdffile")

    def __init__(self, stream_manager=None):
        self._file = None
        self.filesize = 0
        self.startxref_pos = 0
        self.trailer = None
        self.xref_first = None
        self.xref_table = {}
        self.xref_objstm = {}
        self.objstm_objects = {}
        self.page_objects = []
        self.pdfobjects = PDFObjectGroup()
        self.stream_manager = stream_manager or StreamManager()
        # Create an publish the object resolver
        self.resolver = PDFObjectResolver(self)
        PDFResolver.set_resolver(self.resolver)
        # Create a global font manager
        self.fontmgr = FontManager({})

        # Detect the beginning of a PDF Object
        self.re_objstart = re.compile("(\d+) (\d+) obj(.*$)", re.DOTALL)

    def cleanup(self):
        self.stream_manager.cleanup()

    def load(self, filename):
        self.filesize = os.path.getsize(filename)
        self._file = open(filename, "rb")
        self.read_xref()
        self.build_final_xref()

    def find_startxref(self, offset_trailer=160):
        # Look for the first xref from the end
        offset, data = self.filesize, ""
        while not("startxref" in data) or offset == 0:
            offset = max(0, offset - offset_trailer)
            self._file.seek(offset)
            data = self._file.read(offset_trailer) + data

        m = re.search("\sstartxref\s+(\d+)\s+%%EOF", data, re.M)
        if not(m):
            self.error("Problem in PDF file: startxref not found")
            return 0
        self.startxref_pos = int(m.group(1))
        return self.startxref_pos

    def read_xref(self):
        startxref = self.find_startxref()
        xref = None

        while startxref:
            self._file.seek(startxref)
            line = self._file.readline()
            m = re.search("xref\s(.*)", line, re.M|re.DOTALL)
            if (m):
                found_xref = PDFXrefSection(self._file)
                found_xref.read_table(m.group(1))
            elif self.re_objstart.search(line):
                self.info("Xref section not found. Try to load XRef object")
                pdfobject, remain_line = self._parse_object(startxref)
                found_xref = PDFXrefObject(pdfobject)

            startxref = int(found_xref.trailer.get("/Prev", 0))

            if xref: xref.set_older(found_xref)
            xref = found_xref

        self.xref_first = xref

    def build_final_xref(self):
        xref = self.xref_first
        while xref:
            self.trailer = xref.trailer
            self.xref_table.update(xref.table)
            self.xref_objstm.update(xref.objstm)
            xref = xref.newer

    def get_objstm(self, objstm_id):
        return self.objstm_objects.get(objstm_id, None)

    def create_objstm(self, pdfobject):
        self.debug("Create objstm %s" % pdfobject.ident())
        pdfobject.compute()
        pdfobject.stream_decode()
        self.pdfobjects.add_object(pdfobject)
        objstm = PDFObjectStream(pdfobject)
        self.objstm_objects[objstm.ident()] = objstm
        return objstm

    def xref_resolve_object(self, ident):
        offset = self.xref_table.get(ident, 0)
        if offset != 0:
            #print "Object '%s' found at offset: %d" % (ident, offset)
            pdfobject, remain_line = self._parse_object(offset)
            return pdfobject

    def xref_resolve(self, ident):
        # Try to resolve a standard object
        pdfobject = self.xref_resolve_object(ident)
        if pdfobject:
            return pdfobject

        # Find the ObjStm infos that contains that object
        objstm_data = self.xref_objstm.get(ident, 0)
        if objstm_data == 0:
            self.warning("ObjStm id for '%s' not found in xref table" % ident)
            return None

        # If the ObjStm itself is not resolved, resolve it first
        objstm_id = "%d 0" % objstm_data[0]
        object_idx = objstm_data[1]

        objstm = self.get_objstm(objstm_id)
        if not(objstm):
            pdfobject = self.xref_resolve_object(objstm_id)
            if pdfobject: objstm = self.create_objstm(pdfobject)
        if not(objstm):
            self.error("Object '%s' cannot be resolved: ObjStm '%s' not found" \
                      % (ident, objstm_id))
            return None

        # Ok, now get the object from the ObjStm
        pdfobject = objstm.get_object(object_idx)

        return pdfobject

    def resolve_object(self, ident):
        pdfobject = self.pdfobjects.get_object(ident)
        if not(pdfobject):
            #print "Try to resolve object '%s'" % ident
            pdfobject = self.xref_resolve(ident)
            if pdfobject:
                self.pdfobjects.add_object(pdfobject)
        return pdfobject

    def get_object(self, ident):
        ident = ident.replace(" R", "").strip()
        pdfobject = self.resolver.get(ident)
        if pdfobject:
            pdfobject.link_to(self.resolver)
        return pdfobject

    def _parse_object(self, offset):
        pdfobj = None
        parsed_object = None
        remain_line = ""

        self._file.seek(offset)

        while not(parsed_object):
            line = self._file.readline()
            if not(line):
                break

            while line:
                if pdfobj:
                    fields = line.split("endobj", 1)
                    if len(fields) > 1:
                        if fields[0]:
                            pdfobj.append_string(fields[0])
                        pdfobj.compute()
                        remain_line = fields[1]
                        parsed_object = pdfobj
                    else:
                        pdfobj.append_string(line)
                    line = ""
                else:
                    m = self.re_objstart.search(line)
                    if m:
                        number, revision = m.group(1), m.group(2)
                        pdfobj = PDFObject(number, revision,
                                       stream_manager=self.stream_manager)
                        line = m.group(3)
                    else:
                        # drop the line
                        line = ""

        return (parsed_object, remain_line)

    def _expand_pages(self, page_kids):
        # Iterations to make a list of unitary pages (/Page) from a list
        # containing group of pages (/Pages). The iterations stop when all
        # The objects in the list are replaced by unit pages and not
        # intermediate page groups
        page_list = page_kids
        has_kid = len(page_list)
        while has_kid:
            newlist = []
            has_kid = 0
            for kid in page_list:
                #print kid
                kid.link_to(self.resolver)
                if kid.get_type() == "/Pages":
                    kids = kid.descriptor.get("/Kids")
                    self.debug("Expand page list: %s -> %s" % (kid, kids))
                    has_kid += len(kids)
                elif kid.get_type() == "/Page":
                    kids = [kid]
                else:
                    self.error("%s: %s" % (kid, kid.descriptor.params))
                    self.error("%s: What's wrong? '%s'" % (kid, kid.get_type()))
                    kids = []
                newlist = newlist + kids
            page_list = newlist
        return page_list

    def load_pages(self):
        root = self.trailer.get("/Root")
        catalog = self.get_object(root)
        pages = catalog.descriptor.get("/Pages")
        page_count = int(pages.descriptor.get("/Count"))

        self.info("Found %d pages" % page_count)
        pages.link_to(self.resolver)
        page_kids = pages.descriptor.get("/Kids")
        self.page_objects = self._expand_pages(page_kids)
        if len(self.page_objects) != page_count:
            self.error("Unconsistent pages found: %d vs %d" % \
                  (len(self.page_objects), page_count))


class PDFObjectResolver:
    def __init__(self, pdffile):
        self.pdffile = pdffile

    def get(self, ident, default=None):
        pdfobject = self.pdffile.resolve_object(ident)
        if not(pdfobject): pdfobject = default
        return pdfobject


class PDFObjectGroup(PDFBaseObject):
    """
    Group of the PDF Objects contained in a file. This wrapper is a dictionnary
    of the objects, and consolidates the links between the objects.
    """
    _log = logging.getLogger("pdfscan.pdffile")

    def __init__(self):
        self.pdfobjects = {}
        self.objtypes = {}
        self.unresolved = []

    def count(self):
        return len(self.pdfobjects.values())

    def types(self):
        return self.objtypes.keys()

    def add_object(self, pdfobject):
        self.pdfobjects[pdfobject.ident()] = pdfobject
        objtype = pdfobject.get_type()
        if not(objtype):
            objtype = "misc"
        lst = self.objtypes.get(objtype, [])
        lst.append(pdfobject)
        self.objtypes[objtype] = lst
        self.unresolved.append(pdfobject)

    def get_objects_by_type(self, objtype):
        return self.objtypes.get(objtype, [])

    def get_object(self, ident):
        return self.pdfobjects.get(ident, None)

    def link_objects(self):
        self.debug("%d objects to resolve" % (len(self.unresolved)))
        unresolved = []
        for pdfobj in self.unresolved:
            if pdfobj.link_to(self.pdfobjects):
                unresolved.append(pdfobj)
        self.unresolved = unresolved

    def stream_decode(self):
        for pdfobj in self.pdfobjects.values():
            pdfobj.stream_decode()


class PDFPage:
    def __init__(self, pdf, page, pagenum=0):
        self.pagenum = pagenum
        self.pdf = pdf
        contents = page.descriptor.get("/Contents")
        resources = page.descriptor.get("/Resources")

        if (isinstance(resources, PDFDescriptor)):
            rsc_descriptor = resources
        else:
            rsc_descriptor = resources.descriptor

        rsc_descriptor.link_to(pdf.resolver)
        font = rsc_descriptor.get("/Font")
        if font:
            font.link_to(pdf.resolver)
            if (isinstance(font, PDFDescriptor)):
                fontdict = font.infos()
            else:
                fontdict = font.descriptor.infos()
        else:
            fontdict = {}

        if not(isinstance(contents, list)):
            contents = [contents]

        self.page = page
        self.contents = contents
        self.fontdict = fontdict
        self.fontmgr = FontManager(fontdict, pdf.fontmgr)
        self.streams = []
        
        self.link_to(pdf.resolver)
        self.load_streams()

    def link_to(self, resolver):
        for content in self.contents:
            content.link_to(resolver)

    def load_streams(self):
        for content in self.contents:
            stream = PDFContentStream(content, self.fontmgr)
            self.streams.append(stream)

    def find_fonts(self):
        return self.fontmgr.get_used()


class PDFXrefSection(PDFBaseObject):
    """
    Section starting by 'xref' and followed by the 'trailer'. The xref data
    contain information about how to access to objects in the file and is
    therefore a crucial part of the object resolution.
    """
    _log = logging.getLogger("pdfscan.xref")

    _re_desc = re.compile("(<<(?:(?<!<)<(?!<)|[^<>]|(?<!>)>(?!>))*>>)",
                          re.MULTILINE)

    def __init__(self, fd):
        self.trailer = None
        self.table = {}
        self.objstm = {}
        self._file = fd
        self.older = None
        self.newer = None

    def set_older(self, older):
        self.older = older
        older.newer = self

    def _xref_fill_entry(self, fields, obj_id):
        offset, revision, what = fields
        if what == "n":
            ident = "%d %d" % (obj_id, int(revision))
            self.table[ident] = int(offset)

    def read_table(self, linestart=""):
        line = linestart.strip() or self._file.readline()
        subsection = line.split()

        while subsection[0] != "trailer":
            start_ref = int(subsection[0])
            object_count = int(subsection[1])
            if len(subsection) == 5:
                self._xref_fill_entry(subsection[2:], start_ref)
                start_ref += 1
                object_count -= 1

            for i in range(object_count):
                line = self._file.readline()
                self._xref_fill_entry(line.split(), start_ref+i)

            line = self._file.readline()
            subsection = line.split()

        #print len(self.table.values())

        if subsection[0] == "trailer":
            data = " ".join(subsection)
        
        # Ensure we have a complete dictionnary
        while not(">>" in data):
            data += self._file.readline()

        m = self._re_desc.search(data)
        if not(m):
            self.error("Problem in PDF file: cannot find valid trailer")
            return
        self.trailer = PDFDescriptor(string=m.group(1))
        self.trailer.compute()


class PDFStreamHandler:
    """
    Core abstract class in charge to handle the stream of <pdfobject>
    """
    def __init__(self, pdfobject):
        self.stream_object = pdfobject

    def ident(self):
        return self.stream_object.ident()
    def debug(self, text):
        self.stream_object.debug(text)
    def warning(self, text):
        self.stream_object.warning(text)
    def error(self, text):
        self.stream_object.error(text)
    def info(self, text):
        self.stream_object.info(text)

class PDFXrefObject(PDFStreamHandler):
    """
    A specific object that contains XRef entries in binary format. It is an
    alternative to the xref section.
    """
    def __init__(self, pdfobject):
        PDFStreamHandler.__init__(self, pdfobject)
        self.trailer = pdfobject.descriptor
        self.table = {}
        self.objstm = {}
        self.older = None
        self.newer = None

        if pdfobject.descriptor.get("/Type") != "/XRef":
            self.error("Not an XRef object. Give up")
            return

        _format = pdfobject.descriptor.get("/W")
        _format = _format.replace("[", "").replace("]", "")
        self._format = [ int(f) for f in _format.split() ]

        # An /XRef object must contains a stream
        pdfobject.stream_decode()
        self.data = pdfobject.stream_text()
        self.read_table()

    def set_older(self, older):
        self.older = older
        older.newer = self

    def _xref_fill_entry(self, fields, obj_id):
        offset, revision, what = fields
        if what == "n":
            ident = "%d %d" % (obj_id, int(revision))
            self.table[ident] = int(offset)
            self.debug("Record xref entry: '%s' @ %s" % (ident, offset))

    def _xref_fill_objstm(self, fields, obj_id):
        objstm_id, obj_index = fields
        ident = "%d %d" % (obj_id, 0)
        self.objstm[ident] = (objstm_id, obj_index)
        self.debug("Record xref entry in objstm: '%s' @ %s" % \
                   (ident, fields))

    def _int_of(self, string):
        # Convert to int from bytes string that can be of any size
        m = len(string)
        d = 0
        for i, c in enumerate(string):
            d += (1 << (8*(m - i-1))) * struct.unpack("B", c)[0]
        return d

    def read_table(self, linestart=""):
        data = self.data
        fields = 3 * [0]
        entry_size = sum(self._format)
        # TODO: use /Index
        obj_id = 0

        while data:
            first = 0
            last = 0
            for i in range(3):
                last += self._format[i]
                fields[i] = self._int_of(data[first:last])
                first = last

            data = data[entry_size:]
            
            if fields[0] == 1:
                self._xref_fill_entry(fields[1:3] + ["n"], obj_id)
            elif fields[0] == 2:
                self._xref_fill_objstm(fields[1:3], obj_id)

            obj_id += 1


class PDFObjectStream(PDFStreamHandler):
    """
    A PDF Object Stream contains in its stream some compressed PDF objects.
    This class works on a PDF object stream to build the containded PDF objects.
    """
    def __init__(self, pdfobject):
        PDFStreamHandler.__init__(self, pdfobject)
        self._pdfobjects = []

    def pdfobjects(self):
        if not(self._pdfobjects):
            self.compute()
        return self._pdfobjects

    def _getinfo(self, what):
        return self.stream_object.descriptor.get(what)

    def get_object(self, idx):
        if not(self._pdfobjects):
            self.compute()
        if idx < 0 or idx >= len(self._pdfobjects):
            return None
        return self._pdfobjects[idx]

    def parse_object_list(self, data):
        values = data.split()
        objlist = []

        for i in range(0, len(values), 2):
            # The pair is ('object number', byte_offset)
            objlist.append((values[i], int(values[i+1])))
        self.objlist = objlist
        return objlist

    def compute(self):
        _type = self._getinfo("/Type")
        if  _type != "/ObjStm":
            self.error("Cannot read object stream: Invalid type '%s'" % _type)
            return

        nb_objects = int(self._getinfo("/N"))
        objlist_b = int(self._getinfo("/First"))
        stream = self.stream_object.stream_cache

        objlist = self.parse_object_list(stream.read(objlist_b))

        if len(objlist) != nb_objects:
            self.warning("Error in parsing the Stream Object: found %d"\
                         "objects instead of %d" % (len(objlist), nb_object))

        # List Terminator
        objlist.append(("",-1))

        bytes_read = 0
        for i in range(len(objlist)-1):
            # In ObjectStream, a PDF object revision is always '0'
            number, revision = objlist[i][0], "0"

            # The size of the object data is given by the position of the next
            objsize = objlist[i+1][1] - bytes_read
            if objsize >= 0:
                data = stream.read(objsize)
            else:
                data = stream.read()
            bytes_read += len(data)
            self.debug("Object[%d] in stream: '%s' has %d bytes" % \
                       (i, number, objsize))

            # Build the PDF Object from stream data
            pdfobj = PDFObject(number, revision)
            pdfobj.append_string(data)
            pdfobj.compute()
            self._pdfobjects.append(pdfobj)

        stream.close()


class PDFObject:
    """
    A PDF Object contains the data between the 'obj ... 'endobj' tags.
    It has a unique identifier given by the (number,revision) pair.
    The data contained by a PDF object can be dictionnaries (descriptors),
    stream contents and other stuff.
    """
    # Extract a dictionnary '<<...>>' leaf (does not contain another dict)
    _re_desc = re.compile("(<<(?:(?<!<)<(?!<)|[^<>]|(?<!>)>(?!>))*>>)",
                          re.MULTILINE)

    def __init__(self, number, revision, stream_manager=None):
        self.string = ""
        self.number = number
        self.revision = revision
        self.descriptors = []
        self.descriptor = None
        self.data = ""
        self.stream = None
        self.outfile = ""
        self.stream_manager = stream_manager or StreamManager()
        self._log = logging.getLogger("pdfscan.pdfobject")
        self.debug("New Object")
        self.re_desc = self._re_desc

    def debug(self, text):
        self._log.debug(self.logstr(text))
    def warning(self, text):
        self._log.warning(self.logstr(text))
    def error(self, text):
        self._log.error(self.logstr(text))
    def info(self, text):
        self._log.info(self.logstr(text))

    def ident(self):
        return "%s %s" % (self.number, self.revision)

    def __repr__(self):
        return "(%s R)" % self.ident()

    def __int__(self):
        return int(self.data)

    def logstr(self, text):
        return "Object [%s %s]: %s" % (self.number,self.revision,text)

    def append_string(self, string):
        self.string = self.string + string

    def compute(self):
        string = self.string

        s = re.split("stream\s", string, re.MULTILINE)
        if len(s) > 1:
            self.debug("Contains stream")
            self.stream = s[1].strip()

        string = s[0]

        # Iterate to build all the nested dictionnaries/descriptors,
        # from the deepest to the main one
        self.descriptors = []
        while True:
            descs = self.re_desc.findall(string)
            if not(descs):
                break
            for desc_str in descs:
                desc = PDFDescriptor(string=desc_str)
                string = string.replace(desc_str,
                            "{descriptor(%d)}" % len(self.descriptors))
                self.descriptors.append(desc)
            
        self.debug("Found %d descriptors" % len(self.descriptors))

        for descobj in self.descriptors:
            descobj.compute(descriptors=self.descriptors)

        if self.descriptors:
            self.descriptor = self.descriptors[-1]
        else:
            self.descriptor = PDFDescriptor()

        self.data = re.sub("{descriptor\(\d+\)}", "",
                           string, flags=re.MULTILINE).strip()
        self.debug("Data: '%s'" % self.data)

    def stream_decode(self):
        if not(self.stream):
            return
        self.debug("Try to decode stream...")

        # Consolidate stream buffer from the /Length information
        stream_size = int(self.descriptor.get("/Length"))
        self.stream = self.stream[0:stream_size]

        # Put the stream in a cache
        self.stream_cache = self.stream_manager.cache(number=self.number,
                                                      revision=self.revision)

        method = self.descriptor.get("/Filter")
        if method == "/FlateDecode":
            method = "zlib"
        elif method == "/DCTDecode":
            # This is JPEG. Just dump it
            self.warning("this is a JPEG stream")
            method = ""
        elif method != "":
            self.error("don't know how to decode stream with filter '%s'" \
                     % method)
            return

        self.stream_cache.write(self.stream, compress_type=method)

    def stream_text(self):
        if not(self.stream):
            return ""
        data = self.stream_cache.read()
        self.stream_cache.close()
        return data

    def get_type(self):
        _type = self.descriptor.get("/Type")
        if _type:
            return _type
        if self.stream:
            return "stream"
        if pdfstring_is_list(self.data):
            return "list"
        if self.descriptor.is_name_tree_node():
            return "name tree"

    def link_to(self, pdfobjects):
        self.debug("Link objects")
        for desc in self.descriptors:
            desc.link_to(pdfobjects)

        if pdfstring_is_list(self.data):
            pass


class PDFDescriptor:
    """
    Contains the data between the << ... >> brackets in PDF objects. It is
    a dictionnary that can contain other descriptors/dictionnaries.
    """
    # Unique identifier for these objects
    _id = 0

    # Detect the dictionnary fields covering these cases:
    # <<
    #  /Type /Page                    : the value is another keyword
    #  /Contents 5 0 R                : the value is a string up next keyword
    #  /Resources 4 0 R                   
    #  /MediaBox [0 0 595.276 841.89] : the value is an array
    #  /Parent 12 0 R
    # >>
    _re_dict = re.compile("/\w+\s*/[^/\s]+|/\w+\s*\[[^\]]*\]|/\w+\s*[^/]+")

    # Extract a dictionnary keyword
    _re_key = re.compile("(/[^ \({/\[<]*)")

    # Extract the substituted descriptors
    _re_descobj = re.compile("{descriptor\((\d+)\)}")

    # Find the PDF object references
    _re_objref = re.compile("(\d+ \d+ R)")

    def __init__(self, string=""):
        self._ident = self._get_ident()
        self.string = string
        self.params = {}
        self._log = logging.getLogger("pdfscan.descriptor")

        self.re_dict = self._re_dict
        self.re_key = self._re_key
        self.re_descobj = self._re_descobj
        self.re_objref = self._re_objref

    def _get_ident(self):
        _id = PDFDescriptor._id
        PDFDescriptor._id += 1
        return _id

    def ident(self):
        return self._ident

    def debug(self, text):
        self._log.debug("Descriptor [%d]: %s" % (self._ident, text))
    def error(self, text):
        self._log.error("Descriptor [%d]: %s" % (self._ident, text))
    def info(self, text):
        self._log.info("Descriptor [%d]: %s" % (self._ident, text))
    def warning(self, text):
        self._log.warning("Descriptor [%d]: %s" % (self._ident, text))

    def __repr__(self):
        return "desc[%d]" % self._ident

    def normalize_fields(self, string):
        string = string.replace(">>", "")
        string = string.replace("<<", "")
        string = string.replace("\n", " ")
        fields = self.re_dict.findall(string)
        fields = [ f.strip() for f in fields if (f and f.strip()) ]
        return fields

    def compute(self, descriptors=None):
        lines = self.normalize_fields(self.string)
        for line in lines:
            m = self.re_key.match(line)
            if not(m):
                continue
            param = m.group(1)
            value = line.replace(param, "").strip()
            m = self.re_descobj.match(value)
            if m and descriptors:
                value = descriptors[int(m.group(1))]
            self.params[param] = value

        self.debug(self.params)

    def get(self, param, default=""):
        return self.params.get(param, default)
    
    def values(self):
        return self.params.values()

    def keys(self):
        return self.params.keys()

    def infos(self):
        return self.params

    def is_name_tree_node(self):
        if self.get("/Limits") or self.get("/Names") or self.get("/Kid"):
            return True
        else:
            return False

    def link_to(self, pdfobjects):
        unresolved = 0
        for param, value in self.params.items():
            # Point to something else than a string? Skip it
            if not(isinstance(value, str)):
                continue

            objects = []
            objrefs = self.re_objref.findall(value)
            value2 = value
            #print value, objrefs
            for objref in objrefs:
                o = pdfobjects.get(objref.replace(" R", ""), None)
                # If the object is missing, keep the reference for another trial
                if not(o):
                    self.warning("Object '%s' not resolved" % objref)
                    unresolved += 1
                    o = objref
                objects.append(o)
                value2 = value2.replace(objref, "", 1)

            if not(objects):
                continue

            if pdfstring_is_list(value):
                if (value2[1:-1].strip()):
                    #print value2, objects
                    self.warning("Problem: cannot substitute objects: '%s'" \
                                 % value)
                else:
                    self.params[param] = objects
                    self.debug("Substitute %s: %s" % (param, objects))
            else:
                if value2.strip() or len(objects) > 1:
                    self.warning("Problem: cannot substitute object" % value)
                else:
                    self.params[param] = objects[0]
                    self.debug("Substitute %s: %s" % (param, objects[0]))

        return unresolved
 

class StreamManager(PDFBaseObject):
    CACHE_REFRESH = 1
    CACHE_REMANENT = 2
    CACHE_TMPDIR = 4
    CACHE_DELONCLOSE = 8

    _log = logging.getLogger("pdfscan.pdffile")

    def __init__(self, cache_method="file", cache_dirname="", flags=0):
        self.cache_method = cache_method
        self.cache_format = "pdfstream.%(number)s.%(revision)s"
        self.cache_dirname = cache_dirname
        self.cache_files = []
        self.flags = flags
        # Don't want to remove something in a user directory
        if cache_dirname: self.flags = self.flags | self.CACHE_REMANENT

    def cleanup(self):
        if (self.cache_method != "file"):
            return

        if (self.flags & self.CACHE_REMANENT):
            if (self.flags & self.CACHE_TMPDIR):
                self.warning("'%s' not removed" % (self.cache_dirname))
            return

        if (self.flags & self.CACHE_TMPDIR):
            self.debug("Remove cache directory '%s'" % (self.cache_dirname))
            shutil.rmtree(self.cache_dirname)
        else:
            for fname in self.cache_files:
                print "shutil.remove(", fname

    def cache(self, **kwargs):
        if self.cache_method == "file":
            return self.cache_file(kwargs)
        else:
            return self.cache_memory(kwargs)
    
    def cache_file(self, kwargs):
        if not(self.cache_dirname):
            self.cache_dirname = tempfile.mkdtemp()
            self.flags = self.flags | self.CACHE_TMPDIR | self.CACHE_DELONCLOSE

        if not(os.path.exists(self.cache_dirname)):
            os.mkdir(self.cache_dirname)

        cache_path = os.path.join(self.cache_dirname,
                                  self.cache_format % kwargs)
        stream_cache = StreamCacheFile(cache_path, flags=self.flags)
        self.cache_files.append(cache_path)
        return stream_cache

    def cache_memory(self, kwargs):
        stream_cache = StreamCacheMemory(flags=self.flags)
        return stream_cache


class StreamCache:
    def __init__(self, outfile, flags=0):
        self.flags = flags

    def decompress(self, data, compress_type):
        if not(compress_type):
            return data
        if compress_type == "zlib":
            return zlib.decompress(data)

class StreamCacheFile(StreamCache):
    def __init__(self, outfile, flags=0):
        self.flags = flags
        self.outfile = outfile
        self._file = None

    def write(self, data, compress_type=""):
        if ((self.flags & StreamManager.CACHE_REFRESH)
            or not(os.path.exists(self.outfile))):
            data = self.decompress(data, compress_type)
            f = open(self.outfile, "w")
            f.write(data)
            f.close()

    def read(self, size=-1):
        if not(self._file):
            self._file = open(self.outfile)
        if size >= 0:
            data = self._file.read(size)
        else:
            data = self._file.read()
        return data

    def close(self):
        if (self._file):
            self._file.close()
        if (not(self.flags & StreamManager.CACHE_REMANENT) and \
            (self.flags & StreamManager.CACHE_DELONCLOSE)):
            os.remove(self.outfile)

class StreamCacheMemory(StreamCache):
    def __init__(self, flags=0):
        self.flags = flags
        self._buffer = ""
        self._read_pos = 0

    def write(self, data, compress_type=""):
        self._buffer += self.decompress(data, compress_type)

    def read(self, size=-1):
        remain = len(self._buffer)-self._read_pos
        if size >= 0:
            size = min(size, remain)
        else:
            size = remain
        _buf = self._buffer[self._read_pos:self._read_pos+size]
        self._read_pos += size
        return _buf

    def close(self):
        if (self.flags & StreamManager.CACHE_DELONCLOSE):
            del self._buffer
            self._buffer = None



def extract_string_objects(data, re_pattern, replace_fmt,
                           delims=None, object_cls=None,  object_id=0,
                           **kwargs):

    if isinstance(re_pattern, str):
        strings_found = re.findall(re_pattern, data, re.M|re.DOTALL)
    else:
        strings_found = re_pattern.findall(data)

    #print strings_found
    strings_objects = []
    for i, to in enumerate(strings_found):
        repl = replace_fmt % (i+object_id)
        if delims:
            to = delims[0] + to + delims[1]
            repl = delims[0] + repl + delims[1] 
        data = data.replace(to, repl, 1)
        if object_cls:
            strings_objects.append(object_cls(to, **kwargs))
        else:
            strings_objects.append(to)
    return (strings_objects, data)


class PDFContentStream(PDFStreamHandler):
    """
    Data between the 'stream ... endstream' tags in a PDF object used as
    content (and not as image or object storage).
    """
    def __init__(self, pdfobject, fontmgr=None):
        PDFStreamHandler.__init__(self, pdfobject)
        self.data = ""
        self.qnode_root = None
        self.textobjects = None
        self.fontmgr = fontmgr or FontManager({})
        pdfobject.stream_decode()
        self.extract_textobjects(pdfobject.stream_text())
        self.make_graph_tree()

    def extract_textobjects(self, data):
        fields = re.split("((?<=\s)BT(?=\s)|(?<=\s)ET(?=\s))", data)

        start_text = False
        textdata = ""
        textobject = None
        textobjects = []

        for field in fields:
            if field == "BT":
                start_text = True
                textdata = ""
            elif field == "ET":
                textobject = PDFTextObject(textdata, fontmgr=self.fontmgr)
                data = data.replace(textdata,
                                    " textobj(%d) " % len(textobjects), 1)
                textobjects.append(textobject)
                start_text = False
            elif start_text:
                textdata += field

        self.debug("Found %d textobjects" % len(textobjects))
        self.textobjects = textobjects
        self.data = data

    def make_graph_tree(self):
        graph_stacks = re.split("(q\s|\sQ)", self.data)

        self.qnode_root = GraphState()
        qnode = self.qnode_root
        for field in graph_stacks:
            if "q" in field:
                qnode = qnode.push(GraphState())
            elif "Q" in field:
                qnode = qnode.pop()
            elif field.strip():
                qnode.set_data(field)
                qnode.fill_textobjects(self.textobjects)

    def dump(self):
        self.qnode_root.dump()



class PDFMatrix(PDFBaseObject):
    """
             | a  b  0 |
        Tm = | c  d  0 |
             | e  f  1 |

        [x , y , 1] = [x1, y1, 1] x Tm1
        [x1, y1, 1] = [x2, y2, 1] x Tm2
        
     => [x , y , 1] = [x2, y2, 1] x Tm2 x Tm1

    """
    IDENT = [1, 0, 0, 1, 0, 0]

    def __init__(self, vector):
        self.vector = vector

    def tx(self):
        return self.vector[4]

    def ty(self):
        return self.vector[5]

    def scale(self):
        a, b, c, d, e, f = self.vector
        # Horizontal orientation
        if (abs(a) == abs(d) and b == 0 and c == 0):
            return abs(a)
        # vertical orientation
        if (abs(b) == abs(c) and a == 0 and d == 0):
            return abs(b)
        # Always return the first even if something is weird
        self.warning("Cannot interpret Tm matrix scale: %s" % self)
        return a
    
    def __str__(self):
        return str(self.vector)

    def __len__(self):
        return len(self.vector)

    def __mul__(self, vector):
        a, b, c, d, e, f = self.vector
        if len(vector) == 6:
            ar, br, cr, dr, er, fr = vector.vector
            a2 = a * ar + b * cr + 0 * er
            b2 = a * br + b * dr + 0 * fr
            c2 = c * ar + d * cr + 0 * er
            d2 = c * br + d * dr + 0 * fr
            e2 = e * ar + f * cr + 1 * er        
            f2 = e * br + f * dr + 1 * fr        

            m = PDFMatrix([a2,b2,c2,d2,e2,f2])
            return m
        else:
            x, y = vector[0:2]
            x2 = a * x + c * y + e
            y2 = b * x + d * y + f
            return [x2, y2, 1]


class GraphState:
    """
    Graphic state starts with 'q' and ends with 'Q' in content stream.
    It can contain other graphic states and/or text objects.
    """
    def __init__(self):
        self._parent = None
        self._children = []
        self._level = 0
        self._data = ""
        self.textobjects = []
        self.matrix = PDFMatrix(PDFMatrix.IDENT)

    def level(self):
        return self._level

    def set_parent(self, qnode):
        self._parent = qnode
        self._level = qnode.level()+1

    def push(self, qnode):
        self._children.append(qnode)
        qnode.set_parent(self)
        return qnode

    def pop(self):
        qnode = self._parent
        return qnode

    def set_data(self, data, textobjects=None):
        self._data = data
        if textobjects:
            self.fill_textobjects(textobjects)
        self.extract_matrix()

    def fill_textobjects(self, textobjects):
        #print self._data #***
        tos = re.findall(" (textobj\(\d+\))", self._data)
        for to in tos:
            m = re.match("textobj\((\d+)\)", to)
            if m:
                textobject = textobjects[int(m.group(1))]
                textobject.set_graphstate(self)
                self.textobjects.append(textobject)

        self._data = re.sub(" textobj\(\d+\)", "",
                       self._data, flags=re.MULTILINE).strip()

    def extract_matrix(self):
        m = re.search("("+6*"[^\s]+\s+"+"cm"+")", self._data)
        if m:
            vector = [ float(v) for v in m.group(1).split()[0:6] ]
            self.matrix = PDFMatrix(vector)

    def dump(self):
        s = self._level * "  " + "q '" + self._data + "'"
        print s
        for q in self._children:
            q.dump()
        s = self._level * "  " + "Q"
        print s


class PDFTextObject:
    """
    Data between the 'BT' and 'ET' tokens found in content streams.
    """
    _font_op_pattern = "/[^\s]+\s+[^\s]+\s+Tf"

    # Detect a 'Tf', 'Tm', 'Tj', 'TJ', Td, TD operator sequence in a text object
    # To use only when strings are extracted and replaced by their reference
    _re_seq = re.compile("(" + _font_op_pattern + "|"+\
                         6*"[^\s]+\s+"+"Tm"+"|"+\
                         "\(textcontent\{\d+\}\)\s*Tj|"+\
                         "\[[^\]]*\]\s*TJ|"+\
                         "[^\s]+\s+[^\s]+\s+T[dD])", re.MULTILINE)

    # Find a font setup operator, like '/F10 9.47 Tf'
    _re_font = re.compile("("+_font_op_pattern+")", re.MULTILINE)

    # Find a sequence '(...\(...\)...) Tj'
    _re_text_show1 = re.compile("(\((?:" + "[^()]" + "|" +\
                                      r"(?<=\\)\(" + "|" +\
                                      r"(?<=\\)\)" + ")*\)\s*Tj)", re.M)
                                
    # Find a sequence '[...\[...\]...] TJ'
    _re_text_show2 = re.compile("\[((?:" + "[^\[\]]" + "|" +\
                                        r"(?<=\\)\[" + "|" +\
                                        r"(?<=\\)\]" + ")*)\]\s*TJ", re.M)

    def __init__(self, data, fontmgr=None):
        self.data = data
        self.matrix = PDFMatrix(PDFMatrix.IDENT)
        self.fontmgr = fontmgr or FontManager({})
        self.qnode = None
        self.strings = []
        self.textsegments = []
        self.textlines = []
        self.extract_strings()
        self.extract_matrix()
        self.parse_data()

    def set_graphstate(self, gs):
        self.qnode = gs

    def set_fontmanager(self, fontmgr):
        self.fontmgr = fontmgr

    def matrix_absolute(self):
        # The textobject matrix change is the last one, so on the full left
        m = self.matrix

        # We climb the graph stack from the deepest (newer) to the upper
        # (oldest) node so:
        # Absolute Matrix = Newest (m) x ... x Oldest (qnode.matrix)
        qnode = self.qnode
        while qnode:
            m = m * qnode.matrix 
            qnode = qnode.pop()
        return m

    def extract_matrix(self):
        m = re.search("("+6*"[^\s]+\s+"+"Tm"+")", self.data)
        if m:
            vector = [ float(v) for v in m.group(1).split()[0:6] ]
            self.matrix = PDFMatrix(vector)
    
    def extract_strings(self):
        #print self.data
        objects, data = extract_string_objects(self.data, self._re_text_show1,
                                               "(textcontent{%d}) Tj")
        self.strings = objects                                       
        objects, data = extract_string_objects(data, self._re_text_show2,
                                               "textcontent{%d}",
                                               delims=["[","]"],
                                               object_id=len(self.strings))
        #print data
        self.strings += objects
        self.data = data

    def _newline(self):
        linerow = []
        self.textlines.append(linerow)
        return linerow

    def get_font(self, font, size, scale):
        return self.fontmgr.get_font(font, float(size)*scale)

    def parse_data(self):
        linerow = self._newline()
        textline = PDFTextSegment("", PDFMatrix(PDFMatrix.IDENT))
        linerow.append(textline)

        # Find the operator sequences
        operators = self._re_seq.findall(self.data)

        font, size = "", 1
        last_key = ""

        for tx in operators:
            fields = tx.split()
            key = fields[-1]

            # Found a font setup, memorize the fontname and fontsize base
            if key == "Tf":
                font = fields[0]
                size = fields[1]
            # Found the matrix setup, memorize it
            elif key == "Tm":
                vector = [ float(c) for c in fields[0:6]]
                self.matrix = PDFMatrix(vector)
            # Found a text positionning
            elif key in ("Td", "TD"):
                tx, ty = [ float(c) for c in fields[0:2]]
                matrix = PDFMatrix([1, 0, 0, 1, tx, ty])
                textline = PDFTextSegment("", matrix)
                self.textsegments.append(textline)
                if matrix.ty() != 0:
                    linerow = self._newline()
                linerow.append(textline)
            # When text is shown, the current font/size setup applies and is
            # then recorded
            elif "Tj" in key or "TJ" in key:
                m = re.search("textcontent\{(\d+)\}", tx)
                text_string = self.strings[int(m.group(1))]
                scale = self.matrix.scale()
                #print font, size, scale #*****
                pdffont = self.get_font(font, size, scale)
                text_shown = PDFTextShow(text_string, pdffont)
                textline.add_text_show(text_shown)
            last_key = key

class PDFTextSegment:
    """
    A text segment is a portion of text related to a text position operator 'Td'
    or 'TD'. It contains all the texts shown related to this position, signaled
    with the 'Tj' and 'TJ' tokens
    """
    def __init__(self, data, matrix):
        self.matrix = matrix
        self.data = data
        self.strings = None
        self.text_shown = []

    def __str__(self):
        s = ""
        for o in self.text_shown:
            s += str(o)
        return s

    def text(self):
        s = " ".join([o.text() for o in self.text_shown])
        return s

    def set_strings(self, strings):
        self.strings = strings

    def add_text_show(self, text_shown):
        self.text_shown.append(text_shown)


class PDFTextShow:
    """
    Data between the '( )' of the 'Tj' operator or '[ ]' of the 'TJ' operator
    that is intended to be shown.
    """
    _re_textascii = re.compile(r"\(((?:[^)]|(?<=\\)\))*)\)", re.M)
    _re_textunicode = re.compile(r"<([^>]+)>", re.M)
    _codec_handler_installed = {}

    def __init__(self, data, font):
        self.data = data
        self.font = font
        self.encode = codecs.getencoder("latin1")
        if not(self._codec_handler_installed):
            codecs.register_error("substitute", PDFTextShow._encode_subs)
            self._codec_handler_installed["substitute"] = PDFTextShow._encode_subs

    def __str__(self):
        return self.data.replace("\n", " ")

    def text(self):
        textdata = self._re_textascii.findall(self.data)
        textdata = "".join(textdata).replace("\(", "(").replace("\)", ")")
        if textdata:
            return textdata
        if (self.font.tounicode):
            textdata = self._re_textunicode.findall(self.data)
            s = u" ".join(self.font.tounicode.decode(textdata))
            return self.encode(s, "substitute")[0]
        else:
            return ""

    def get_font(self):
        return self.font

    @classmethod
    def _encode_subs(cls, exc):
        if not isinstance(exc, UnicodeEncodeError):
            return u""
        l = []
        for c in exc.object[exc.start:exc.end]:
            l.append(u"&#x%x;" % ord(c))
        return (u"".join(l), exc.end)


class PDFFont:
    def __init__(self, fontobject, fontsize, tounicode=None):
        self.fontobject = fontobject
        self.fontsize = fontsize
        self.tounicode = tounicode

    def key(self):
        key = "%s/%6.2f" % (self.name(), self.size())
        return key

    def __cmp__(self, other):
        a = (cmp(self.name(), other.name()) or
             cmp(self.size(), other.size()))
        return a

    def name(self):
        return self.fontobject.descriptor.get("/BaseFont")

    def size(self):
        return self.fontsize

class FontManager:
    def __init__(self, fontdict, global_fontmgr=None):
        self.fontdict = fontdict
        self.fontused = {}
        self.tounicode = {}
        self.global_fontmgr = global_fontmgr
        self.resolver = PDFResolver.get_resolver()

    def get_pdffont(self, fontobj, fontsize):
        key = fontobj.descriptor.get("/BaseFont")+"/"+"%6.2f" % fontsize
        if self.fontused.has_key(key):
            return self.fontused.get(key)
        elif self.global_fontmgr:
            pdffont = self.global_fontmgr.get_pdffont(fontobj, fontsize)
            self.fontused[key] = pdffont
        else:
            pdffont = self._make_pdffont(fontobj, fontsize)
            self.fontused[key] = pdffont
        return pdffont

    def _make_pdffont(self, fontobj, fontsize):
        fontobj.link_to(self.resolver)
        pdfobject = fontobj.descriptor.get("/ToUnicode")
        if pdfobject:
            pdfobject.link_to(self.resolver)
            tuc = self._get_tounicode(pdfobject)
        else:
            tuc = None
        pdffont = PDFFont(fontobj, fontsize, tuc)
        return pdffont

    def _get_tounicode(self, pdfobject):
        key = pdfobject.ident()
        if self.tounicode.has_key(key):
            tuc = self.tounicode.get(key)
        else:
            tuc = ToUnicode(pdfobject)
            self.tounicode[key] = tuc
        return tuc

    def get_font(self, fontref, size):
        fontobj = self.fontdict.get(fontref)
        if not(fontobj):
            return None
        return self.get_pdffont(fontobj, size)

    def get_used(self):
        return self.fontused.values()


class ToUnicode(PDFStreamHandler):
    """
    Handle the /ToUnicode CMap object found in a font, in order to be able to
    translate the text content to readable text
    """
    _re_token = re.compile("(" + \
             "(?:\d+\s+(?:begincodespacerange|beginbfchar|beginbfrange))" + "|"\
             "(?:endcodespacerange|endbfchar|endbfrange)" + \
             ")", re.M)

    def __init__(self, pdfobject):
        PDFStreamHandler.__init__(self, pdfobject)
        self.charmaps = []
        pdfobject.stream_decode()
        self.data = pdfobject.stream_text()
        self.parse_cmap(self.data)
        self.debug("Create a ToUnicode object for '%s'" % pdfobject.ident())

    def parse_cmap(self, data):
        flds = self._re_token.split(data)

        bfchar = None
        bfrange = None
        for fld in flds:
            if "begincodespacerange" in fld:
                # TODO
                pass
            elif "beginbfchar" in fld:
                n = int(fld.split()[0])
                bfchar = BfRange(n)
            elif "beginbfrange" in fld:
                n = int(fld.split()[0])
                bfrange = BfRange(n)
            elif "endcodespacerange" in fld:
                pass
            elif "endbfchar" in fld:
                self.add_bfrange(bfchar)
                bfchar = None
            elif "endbfrange" in fld:
                self.add_bfrange(bfrange)
                bfrange = None
            elif bfchar:
                fld = re.sub("<\s+", "<", fld)
                fld = re.sub("\s+>", ">", fld)
                data = fld.split()
                for i in range(0, len(data), 2):
                    bfchar.add_mapstr(data[i], data[i], data[i+1])
            elif bfrange:
                fld = re.sub("<\s+", "<", fld)
                fld = re.sub("\s+>", ">", fld)
                data = fld.split()
                for i in range(0, len(data), 3):
                    bfrange.add_mapstr(data[i], data[i+1], data[i+2])
 
    def add_bfrange(self, bfrange):
        self.charmaps.extend(bfrange.charmaps)
        self.charmaps.sort()

    def get_uccode(self, bfchar):
        mustbe_in_next = False
        for m in self.charmaps:
            if bfchar >= m.bffirst:
                if bfchar <= m.bflast:
                    return m.uccode + (bfchar - m.bffirst)
                else:
                    mustbe_in_next = True
            elif mustbe_in_next:
                return 0
        return 0

    def decode_string(self, data):
        ul = []
        for i in range(0, len(data), 4):
            s = data[i:i+4]
            #print s
            ul.append(unichr(self.get_uccode(int(s,16))))
        return u"".join(ul)

    def decode(self, data):
        if isinstance(data, list):
            return [self.decode_string(s) for s in data]
        else:
            return self.decode_string(data)


class CharMap:
    def __init__(self, bffirst, bflast, uccode):
        self.bffirst = bffirst
        self.bflast = bflast
        self.uccode = uccode

    def __cmp__(self, other):
        return cmp(self.bffirst, other.bffirst)

class BfRange:
    def __init__(self, entry_count):
        self.entry_count = entry_count
        self.charmaps = []

    def add_mapstr(self, bffirst_str, bflast_str, ucfirst_str):
        # Take strings like <045D>
        bffirst = int(bffirst_str[1:-1], 16)
        bflast = int(bflast_str[1:-1], 16)
        ucfirst = int(ucfirst_str[1:-1], 16)
        self.charmaps.append(CharMap(bffirst, bflast, ucfirst))


#
# Starting from here is the command stuff
#
#
import textwrap

class BasicCmd:
    def __init__(self):
        pass
    def setup_parser(self, parser):
        return True
    def help(self, cmd):
        if self.__doc__:
            return self.__doc__
        else:
            return None

class PageLayoutCmd(BasicCmd):
    """
    Show the position and fonts used for each text line contained by a page
    """
    def __init__(self, scanner):
        self.scanner = scanner
        layout_fmt = "%5s %5s | %5s %5s | %8s | "
        self.padding = layout_fmt % (" "," "," "," "," ")
        self.headline = layout_fmt % (5*"_",5*"_",5*"_",5*"_",8*"_")
        self.header = layout_fmt % ("dX","dY","X","Y","FONTS")
        self.width = 90
        self.show_matrix = False
        self.raw_text = False
        self.pt_factor = 1

    def setup_parser(self, parser):
        parser.add_argument("-w", "--width",
               help="Width of the printed layout information")
        parser.add_argument("-m", "--show-matrix", action="store_true",
               help="Print absolute Transformation Matrix for each textobject")
        parser.add_argument("-r", "--raw-text", action="store_true",
               help="Print the raw text contained by textobjects")

    def run(self, parser, args):
        if args.width:
            self.width = int(args.width)
        if args.show_matrix:
            self.show_matrix = True
        if args.raw_text:
            self.raw_text = True
        
        for pg in self.scanner.page_groups:
            self.print_page_layout(pg)

    def print_page_layout(self, pdf_pages):
        for page in pdf_pages:
            fonts_used = page.find_fonts()
            fonts_used.sort()
            print "\nPage %d fonts used:" % page.pagenum
            for i, font in enumerate(fonts_used):
                print "[%d] %-40s %6.2f pt" % (i, font.name(),
                                               self.pt_factor*font.size())

            print "\nPage %d layout:" % page.pagenum
            content_stream = page.streams[0]
            xp, yp = 0., 0.
            print self.header
            print self.headline
            for textobject in content_stream.textobjects:
                xp, yp = self._print_textobject_layout(textobject, xp, yp,
                                                       fonts_used)

    def _print_textobject_layout(self, textobject, xp, yp, fonts_used):
        wraplen = self.width - len(self.padding)

        m2 = textobject.matrix_absolute()

        for line in textobject.textlines:
            # Track the fonts used per line
            font_line = []
            for seg in line:
                for text_shown in seg.text_shown:
                    font = text_shown.get_font()
                    if not(font):
                        continue
                    idx = fonts_used.index(font)
                    if not(idx in font_line):
                        font_line.append(idx)

            m2 = line[0].matrix * m2
            if self.show_matrix: print "%s" % m2

            x, y = m2.tx(), m2.ty()
            x, y = float(x/72), float(y/72)
            dx, dy = x - xp, y - yp
            info = "%5.2f %5.2f | %5.2f %5.2f | %8s | " % \
                  (dx, dy, x, y, font_line)
            if self.raw_text:
                text = "".join([str(s) for s in line])
            else:
                text = "".join([s.text() for s in line])
            textw = textwrap.wrap(text, wraplen)

            if textw:
                print "%s%s" % (info, textw[0])
                for txt in textw[1:]:
                    print "%s%s" % (self.padding, txt)

            xp, yp = x, y
            for l in line[1:]:
                m2 = l.matrix * m2

        return (xp, yp)

class PageObjectCmd(BasicCmd):
    """
    List the PDF objects used per page
    """
    def __init__(self, scanner):
        self.scanner = scanner

    def run(self, parser, args):
        page_first = 1
        for i, page in enumerate(self.scanner.pdf.page_objects):
            page_num = i+page_first
            contents = page.descriptor.get("/Contents")
            resources = page.descriptor.get("/Resources")
            print "Page %d %s: contents: %s, resources: %s" % \
                                 (page_num, page, contents, resources)
        print

class PdfObjectCmd(BasicCmd):
    """
    Scan data on the PDF objects of the PDF File
    """
    def __init__(self, scanner):
        self.scanner = scanner

    def setup_parser(self, parser):
        group = parser.add_mutually_exclusive_group()
        group.add_argument("-list", "--list-loaded", action="store_true",
               help="List the object loaded by the scanner")
        group.add_argument("-dict", "--dictionnary",
               metavar="'<number> <generation>'",
               help="Show the dictionnary of the object specified by its "\
                    "reference '<number> <generation>'")
        group.add_argument("-dump", "--dump-stream", nargs=2,
               metavar=("'<number> <generation>'","OUTFILE"),
               help="Write the stream content of the object specified by its "\
                    "reference '<number> <generation>'")

    def run(self, parser, args):
        if args.list_loaded:
            self.list_pdfobjects()
        elif args.dictionnary:
            ident = self._sanitize_objref(args.dictionnary)
            if not(ident): return
            self.show_dictionnary(ident)
        elif args.dump_stream:
            ident = self._sanitize_objref(args.dump_stream[0])
            if not(ident): return
            self.dump_stream(ident, args.dump_stream[1])

    def _sanitize_objref(self, ident):
        flds = ident.split()
        if len(flds) != 2:
            print "Invalid object reference: must be in the form "\
                  "'number generation'"
            return ""
        else:
            return "%s %s" % (flds[0], flds[1])

    def show_dictionnary(self, ident):
        pdfobject = self.scanner.pdf.get_object(ident)
        if not(pdfobject):
            print "PDF Object '%s' not found" % ident
            return
        if pdfobject.stream:
            print "PDF Object '%s' has a stream. Its dictionnary:" % ident
        else:
            print "PDF Object '%s' dictionnary:" % ident
        self._print_dictionnary(pdfobject.descriptor)

    def _print_dictionnary(self, descriptor, level=1):
        indent = "  "*level
        print "%s<<" % indent
        for p, v in descriptor.infos().items():
            if isinstance(v, PDFDescriptor):
                print "%s%s:" % (indent, p)
                self._print_dictionnary(v, level=level+1)
            else:
                print "%s%s: %s" % (indent, p, v)
        print "%s>>" % indent

    def list_pdfobjects(self):
        pdfobjects = self.scanner.pdf.pdfobjects
        print "Found %s PDFObjects" % pdfobjects.count()
        print "Found the following PDFObject types:"
        types = pdfobjects.types()
        types.sort()
        total = 0
        for typ in types:
            n_type = len(pdfobjects.get_objects_by_type(typ))
            print " %20s: %5d objects" % (typ, n_type)
            total = total + n_type
        print " %20s: %5d objects" % ("TOTAL", total)

    def dump_stream(self, ident, outfile):
        pdfobject = self.scanner.pdf.get_object(ident)
        if not(pdfobject):
            print "PDF Object '%s' not found" % ident
            return
        if not(pdfobject.stream):
            print "PDF Object '%s' has no stream. Give up." % ident
            return
        pdfobject.stream_decode()
        f = open(outfile, "wb")
        f.write(pdfobject.stream_text())
        f.close()
        print "PDF Object '%s' stream written to file %s" % (ident, outfile)



class PageFontCmd(BasicCmd):
    def __init__(self, scanner):
        self.scanner = scanner
        self.header_fmt = "%4s %-40s %s"
        self.pt_factor = 1
        self.font_unit = "pt"

    def help(self, cmd):
        if cmd == "font_summary":
            _help = "List the fonts used and their size in the specified pages"
        else:
            _help = "List the fonts used and their size for each page"
        return _help

    def setup_parser(self, parser):
        parser.add_argument("-pt", "--point-type",
              help="Point type to use: 'dtp' (default), 'tex'")

    def run(self, parser, args):
        if args.point_type == "tex":
            self.pt_factor = 72.27/72
            self.font_unit = "pt tex"

        if args.name == "font_summary":
            self.print_font_summary()
        else:
            self.print_font_page()

    def print_font_page(self):
        for pg in self.scanner.page_groups:
            self.print_fonts_in_pages(pg)

    def print_fonts_in_pages(self, pdf_pages, show=True):
        if show:
            print self.header_fmt % ("PAGE", "FONT", "SIZE")
            print self.header_fmt % (4*"-", 40*"-", 10*"-")

        for page in pdf_pages:
            fonts_used = page.find_fonts()
            fonts_used.sort()
            for font in fonts_used:
                if show:
                    print "%4d %-40s %6.2f %s" % (page.pagenum, font.name(),
                              self.pt_factor * font.size(), self.font_unit)
            if show: print self.header_fmt % (4*"-", 40*"-", 10*"-")

    def print_font_summary(self):
        pages = []
        for pg in self.scanner.page_groups:
            if not(pg):
                continue
            s = "%d" % (pg[0].pagenum)
            if len(pg) > 1:
                s += "-%d" % (pg[-1].pagenum)
            pages.append(s)

        print "\nFonts used in pages %s:" % (",".join(pages))
        fonts_used = self.scanner.pdf.fontmgr.get_used()
        fonts_used.sort()
        for font in fonts_used:
            print "%-40s %6.2f %s" % \
                  (font.name(), self.pt_factor*font.size(), self.font_unit)


class PDFScannerCommand:
    def __init__(self):
        self._commands = [
             ("page_object", PageObjectCmd),
             ("page_font", PageFontCmd),
             ("page_layout", PageLayoutCmd),
             ("font_summary", PageFontCmd),
             ("pdfobject", PdfObjectCmd)
            ]
        self.commands_to_run = []
        self.pdf = None
        self.page_ranges = []
        self.page_groups = []
        self.fonts_used = {}

    def commands(self):
        return [c[0] for c in self._commands]

    def setup_options(self, parser):
        parser.add_argument("-p", "--pages", action="append",
              help="Page range in the form '<first>[-[<last>]]'")
        parser.add_argument("-v", "--verbose", action="append",
              help="Verbose mode in the form '[group:]level' with level "\
                   "in 'debug', 'info', 'warning', 'error' and "\
                   "group in 'pdffile', 'pdfobject', 'descriptor'")
        parser.add_argument("-c", "--cache-stream-dir",
              help="Directory where to store the decompressed stream")
        parser.add_argument("-m", "--no-cache-stream", action="store_true",
              help="No stream cache on disk used: leave streams in memory")
        parser.add_argument("-d", "--cache-remanent", action="store_true",
              help="Equivalent to -fremanent")
        parser.add_argument("-f", "--cache-flags",
              help="Comma separated list of stream cache setup options: "\
                   "'remanent' and/or 'refresh'")

    def setup_parser(self, parser):
        self.setup_options(parser)

        if not(self._commands):
            return
        partial = True
        subparsers = parser.add_subparsers() #title=title)
        clsused = []
        cmdobjs = []
        for cmd, cls in self._commands:
            # Don't duplicate objects used for several commands
            if cls in clsused:
                cmdobj = cmdobjs[clsused.index(cls)]
            else:
                cmdobj = cls(self)
                cmdobjs.append(cmdobj)
                clsused.append(cls)
            kwargs = {}
            if cmdobj.help(cmd):
                kwargs["help"] = cmdobj.help(cmd)
            p = subparsers.add_parser(cmd, **kwargs)
            partial = cmdobj.setup_parser(p) or partial
            p.set_defaults(run=cmdobj.run, name=cmd)
        return partial

    def prepare(self, parser, options, argslist, pdffile):
        self.options = options
        # Sort the commands in the right order
        cmds = [ args.name for args in argslist ]
        self.commands_to_run = []
        for cmd in self.commands():
            if cmd in cmds:
                i = cmds.index(cmd)
                self.commands_to_run.append(argslist[i])
        
        log_groups = self._option_group_loglevels()
        self.logger_setup(log_groups)

        self.page_ranges = self._option_page_ranges()

        stream_manager = self._option_cache_setup()
        self.pdf = PDFFile(stream_manager=stream_manager)

    def cleanup(self):
        if self.pdf:
            self.pdf.cleanup()

    def run(self, parser, options, argslist, pdffile):
        self.prepare(parser, options, argslist, pdffile)
        self.pdf.load(pdffile)
        self.pdf.load_pages()
        self._build_pages()
        for args in self.commands_to_run:
            args.run(parser, args)

    def _build_pages(self):
        page_count = len(self.pdf.page_objects)
        for page_range in self.page_ranges:
            page_first, page_last = self._page_range(page_range, page_count)
            page_objects = self.pdf.page_objects[page_first-1:page_last]

            pdf_pages = self._build_pages_from_objects(page_objects, page_first)
            self.page_groups.append(pdf_pages)

    def _build_pages_from_objects(self, page_objects, page_first):
        pdf_pages = []
        for i, pg in enumerate(page_objects):
            pagenum = i+page_first
            page = PDFPage(self.pdf, pg, pagenum)
            pdf_pages.append(page)
        return pdf_pages

    def _page_range(self, page_range, max_range):
        if not(page_range): page_range = [1, max_range]
        if page_range[0] == 0: page_range[0] = 1
        if page_range[1] == 0 or page_range[1] > max_range:
            page_range[1] = max_range
        return page_range

    def _option_page_ranges(self):
        page_ranges = []
        if not(self.options.pages):
            page_ranges.append([0, 0])
            return page_ranges

        for page_range in self.options.pages:
            p1, p2 = (page_range + "-x").split("-")[0:2]
            if not(p2):
                p2 = 0
            elif (p2 == "x"):
                p2 = p1
            page_ranges.append([int(p1), int(p2)])

        return page_ranges

    def _option_group_loglevels(self):
        verbose = self.options.verbose
        log_groups = {"pdffile":   "info",
                      "pdfobject": "info",
                      "descriptor": "error",
                      "base": "info"}

        log_levels = ("debug", "info", "warning", "error")

        if not(verbose):
            return log_groups

        groups = log_groups.keys()
        for verbose_opt in verbose:
            group, level = ("all:" + verbose_opt).split(":")[-2:]
            if not(level in log_levels):
                print "Invalid verbose level: '%s'" % level
                continue
            if group == "all":
                for group in groups:
                    log_groups[group] = level
            elif group in groups:
                log_groups[group] = level
            else:
                print "Invalid verbose group: '%s'" % group
                continue
        return log_groups

    def _option_cache_setup(self):
        cache_in_memory = self.options.no_cache_stream
        cache_dirname = self.options.cache_stream_dir
        cache_flags = self.options.cache_flags

        if self.options.cache_remanent:
            if cache_flags:
                cache_flags += ",remanent"
            else:
                cache_flags = "remanent"

        flags = 0
        if cache_flags:
            cache_flags = cache_flags.split(",")
            for cflag in cache_flags:
                if cflag == "remanent":
                    flags = flags | StreamManager.CACHE_REMANENT
                elif cflag == "refresh":
                    flags = flags | StreamManager.CACHE_REFRESH

        if cache_in_memory:
            mgr = StreamManager(cache_method="memory")
        elif cache_dirname:
            cache_dirname = os.path.realpath(cache_dirname)
            if not(os.path.exists(cache_dirname)):
                print "Invalid cache dir: '%s'. Temporary dir used instead" % \
                      cache_dirname
                return None
            mgr = StreamManager(cache_method="file",
                                cache_dirname=cache_dirname,
                                flags=flags)
        else:
            mgr = StreamManager(flags=flags)

        return mgr

    def logger_setup(self, log_groups):
        loglevels = { "error":   logging.ERROR,
                      "warning": logging.WARNING,
                      "info":    logging.INFO,
                      "debug":   logging.DEBUG }

        console = logging.StreamHandler()
        fmt = logging.Formatter("%(message)s")
        console.setFormatter(fmt)

        for group, level in log_groups.items():
            log = logging.getLogger("pdfscan.%s" % group)
            log.setLevel(loglevels.get(level, logging.INFO)-1)
            log.addHandler(console)


def main():
    from argparse import ArgumentParser
    parser = ArgumentParser(description='Scan information from a PDF file')
    parser.add_argument("-D", "--dump-stack", action="store_true",
          help="Dump error stack (debug purpose)")

    scanner = PDFScannerCommand()
    scanner.setup_parser(parser)

    options, remain_args =  parser.parse_known_args()
 
    argslist = []
    remain_args = sys.argv[1:]
    while len(remain_args) > 1:
        args, remain_args =  parser.parse_known_args(remain_args)
        args.remain_args = remain_args
        argslist.append(args)

    if not(remain_args) or remain_args[0] in scanner.commands():
        print "Missing the PDF File"
        parser.parse_args(["-h"])

    error = ErrorHandler()
    if options.dump_stack: error.dump_stack()

    try:
        pdffile = remain_args[0]
        scanner.run(parser, options, argslist, pdffile)
    except Exception, e:
        error.failure_track("Error: '%s'" % (e))

    scanner.cleanup()
    sys.exit(error.rc)

if __name__ == "__main__":
    main()
