# sudo gem install exifr
# ruby rename.rb "/Users/misoclub/Downloads/Photos"

require 'fileutils'
require 'exifr'
require 'exifr/jpeg'

# ターゲットのパス
path = ARGV[0] + "/"
# ファイルの拡張子。とりまjpg関連だけ。
target = "{JPG,jpg,jpeg,JPEG}"
# 書き出しファイル名。
prefix = "img"
# 要注意ファイルサイズ。20Mくらい。厳密には20,971,520
sizeoverbyte = 20000000
# 書き出しディレクトリ名
outdir = "./_out/"
sizeoverdir = "./_sizeover/"
filenames = {}

# 書き出しディレクトリはつど削除。
FileUtils.rm_rf(Dir.glob(path + outdir))

Dir.glob(path + "*.#{target}").each_with_index do |filename, index|

	@exif = EXIFR::JPEG.new(filename)

	if @exif.exif?

		time = @exif.date_time.strftime("%Y%m%d_%H%M%S").to_s
		# time = @exif.date_time_original.strftime("%Y%m%d%H%M%S").to_s

		if !filenames.has_key?(time)
			filenames[time] = 0
		else
			filenames[time] += 1
		end

		newname = filename.gsub(/.+(?=\.[^.]+$)/) { sprintf("%s%s_%03d", prefix, time, filenames[time]) }
		print "#{filename} -> #{newname}\n"

		# サイズオーバーしているファイルはサイズオーバーディレクトリへ移動
		if sizeoverbyte < File.stat(filename).size
			FileUtils.mkdir_p(path + outdir + sizeoverdir)
			FileUtils.cp(filename, path + outdir + sizeoverdir + newname)
		else
			FileUtils.mkdir_p(path + outdir)
			FileUtils.cp(filename, path + outdir + newname)
		end

	end

end

