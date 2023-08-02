def change_file_extension(directory_path, old_extension, new_extension)
  Dir.glob("#{directory_path}/*.#{old_extension}").each do |file|
    new_file = File.join(File.dirname(file), "#{File.basename(file, ".#{old_extension}")}.#{new_extension}")
    File.rename(file, new_file)
    puts "파일 이름 변경: #{file} -> #{new_file}"
  end
end

# 변경하고자 하는 디렉토리 경로
directory_path = "/Users/kim-wongi/Desktop/loaIcon"

# 변경하고자 하는 확장자
old_extension = "webp"
new_extension = "png"

change_file_extension(directory_path, old_extension, new_extension)
