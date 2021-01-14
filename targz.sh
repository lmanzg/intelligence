
if [[ ! -d "$1" ]]; then
	exit 0
fi

cd $1

tar -zcvf $2.tar.gz $2

if [[ -f "$2.tar.gz" ]]; then
	rm $2
fi


