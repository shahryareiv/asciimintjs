#
# filehandlers.rb
# Contains top-level file utility methods
#

module AsciidoctorBibtex

  module FileHandlers
    # Locate a bibliography file to read in given dir
    def FileHandlers.find_bibliography dir
      begin
        candidates = Dir.glob("#{dir}/*.bib")
        if candidates.empty?
          return ""
        else
          return candidates.first
        end
      rescue # catch all errors, and return empty string
        return ""
      end
    end

    # Add '-ref' before the extension of a filename
    def FileHandlers.add_ref filename
      file_dir = File.dirname(File.expand_path(filename))
      file_base = File.basename(filename, ".*")
      file_ext = File.extname(filename)
      return "#{file_dir}#{File::SEPARATOR}#{file_base}-ref#{file_ext}"
    end
  end
end

