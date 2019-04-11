mkdir -p lutao/fruits lutao/vegetables
cd lutao
touch fruits/{apple,tomato} vegetables/{carrots,tomato}
mkdir mnt
mount -t aufs -o dirs=./fruits:./vegetables none ./mnt
