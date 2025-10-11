
.PHONY: 
.DEFAULT_GOAL := build

tag := mysql:5.7-ubuntu
CHECK_CMD := mysql -V ; mysqld -V ;

include ../_env/Makefile

will:
	curl -s 	 | grep 'mysql-5.7' | grep -o '[0-9.]\+-[0-9]\+ubuntu[0-9.]\+' | head -n 1