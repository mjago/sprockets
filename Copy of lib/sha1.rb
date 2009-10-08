require 'digest/sha1'
require 'find'

CODE_PATH = 'C:/gitwork/AD/trunk'

def contents_equal?(path_to_file_1, path_to_file_2)
Digest::SHA1.file(path_to_file_1).hexdigest ==
Digest::SHA1.file(path_to_file_2).hexdigest
end

#~ 10000.times do 
  #~ puts Digest::SHA1.file('test_file').hexdigest
#~ end

def build_file_tree
  @files = {}
  Find.find(CODE_PATH) do |path|
    if File.basename(path)[0] == ?. || File.basename(path)[0] == ?#
      Find.prune       # Don't look any further into system or .git directory.
    else
      %w{.c .h .rb .lkr .feature}.each do |extension|
        if File.extname(path) == extension
          puts path + ' => ' + Digest::SHA1.file(path).hexdigest
  #        puts File.mtime(path)
					puts
        end	
      end	
      next
    end
  end
  #~ exit 2
end

build_file_tree