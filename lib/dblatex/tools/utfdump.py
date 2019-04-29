import codecs
import sys

def main():

    decode = codecs.getdecoder("utf8")
    encode = codecs.getencoder("latin-1")

    f = open(sys.argv[1])
    lineno = 0
    for line in f:
        line = decode(line)[0]
        lineno += 1
        outline = ""
        for uchar in line:
            try:
                o = encode(uchar)[0]
            except:
                o = "?"
            print "U%04X: %s" % (ord(uchar), o)
            outline += o
        print "Line %3d: %s" % (lineno, outline)


if __name__ == "__main__":
    main()
