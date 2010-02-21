#! ruby -Ks

require "FileUtils"
print "flac2mp3 ver0.1b\n"

def getTagText( tagName, path )
  path = '"' + path + '"'
  command = "metaflac.exe --show-tag " << tagName << ' ' << path
  result = `#{command}`
  result.chomp!
  return result.split("=")[1]
end

filePaths = [];
open( ARGV[0] ) do |playlistFile|
  #�ŏ��̍s�͂���Ȃ� TODO ���e���o���f�[�g���ׂ�
  playlistFile.gets()
  flag = false;
  playlistFile.each do |line|
    line.chomp!
    filePaths << line if flag == true
    flag = !flag
  end
end

convertDir = { "source"=>ARGV[1], "dist"=>ARGV[2] };

filePaths.each do |path|

	print path+"����ȃf�[�^���擾��\n"
	title = getTagText( "TITLE", path )
	artist = getTagText( "ARTIST", path )
	album = getTagText( "ALBUM", path )
	date	= getTagText( "DATE", path )
	comment	= getTagText( "COMMENT", path )
	track	= getTagText( "TRACKNUMBER", path )
	genre	= getTagText( "GENRE", path )

	# �ϊ����ƕϊ���̃t�@�C�������m�肷��
	sourceFile = '"' + path + '"'
	targetDir = File.dirname( path );
	targetDir = targetDir.split( convertDir["source"] )[1];
	targetDir = convertDir["dist"] + targetDir;
	targetFileName = targetDir + "\\" + File.basename( path, ".*" ) + ".mp3"
	targetFileName = '"' + targetFileName + '"'

	FileUtils.makedirs( targetDir )

	puts sourceFile+"��ϊ���"
	convertCommand = "flac.exe -dc " << sourceFile
	convertCommand << " | lame64.exe -b 192 -h" << " --tt " << '"' << title << '"'
	convertCommand << " --tn "<< '"' << track << '"'
	convertCommand << " --tg " << '"' << genre << '"'
	convertCommand << " --ty " << '"' << date << '"'
	convertCommand << " --ta " << '"' << artist << '"'
	convertCommand << " --tl " << '"' << album << '"'
	convertCommand << " --add-id3v2"
	convertCommand << " - " << targetFileName

	puts convertCommand
	result = `#{convertCommand}`
end
#path = filePaths[0]

