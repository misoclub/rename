# sudo gem install exifr

require 'fileutils'
require 'exifr'
require 'exifr/jpeg'

target = "JPG"
prefix = "img"


filenames = {}

# 書き出しディレクトリはつど削除。
FileUtils.rm(Dir.glob('./out/*.*'))

Dir.glob("*.#{target}").each_with_index do |filename, index|

	@exif = EXIFR::JPEG.new(filename)

	if @exif.exif?

		time = @exif.date_time.strftime("%Y%m%d%H%M%S").to_s
		# time = @exif.date_time_original.strftime("%Y%m%d%H%M%S").to_s

		if !filenames.has_key?(time)
			filenames[time] = 0
		else
			filenames[time] += 1
		end

		newname = filename.gsub(/.+(?=\.[^.]+$)/) { sprintf("%s%s_%03d", prefix, time, filenames[time]) }
		print "#{filename} -> #{newname}\n"

		FileUtils.mkdir_p("./out/")
		FileUtils.cp(filename, "./out/"+newname)
		
	end

end
