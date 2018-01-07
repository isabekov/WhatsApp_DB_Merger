#! /bin/bash
#  WhatsApp_DB_Merger.sh
#  A wrapper for the WhatsApp_DB_Merger.sql script which merges an old WhatsApp database with a new database into a resulting database.
#  This script copies provided input databases and runs SQL queries on the copies. Direct operation on the databases may corrupt them!
#  The merged database can be used with the "WhatsApp Viewer.exe" GUI application (runs on Linux under Wine) to view the stored chats.
#  License: GPL v2.0
#  Author: Altynbek Isabekov
#  E-mail: aisabekov@ku.edu.tr

OPTIND=1  # A POSIX variable: Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
new_file=""
old_file=""
merged_file=""
verbose=""

show_help () {
	echo "Usage summary:"
	echo -e "      ./WhatsApp_DB_Merger.sh  -o msgstore_old.db -n msgstore_new.db -m merged.db\n"
	echo "Options:"
	echo "-o  old database"
	echo "-n  new database"
	echo -e "-m  resulting (merged) database\n"
	echo "WhatsApp_DB_Merger.sh is a wrapper for the WhatsApp_DB_Merger.sql script which merges an old WhatsApp database with a new database into a resulting database."
}

while getopts "h?vo:n:m:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    v)  verbose="-echo"
        ;;
    o)  old_file=$OPTARG
        ;;
    n)  new_file=$OPTARG
        ;;
    m)  merged_file=$OPTARG
        ;;
    esac
done

echo "Copying files:"
cp -v $old_file msgstore_old.db
cp -v $new_file msgstore_new.db
echo "Running WhatsApp_DB_Merger.sql script..."
sqlite3 -cmd "ATTACH DATABASE \"msgstore_old.db\" AS OLD; ATTACH DATABASE \"msgstore_new.db\" AS NEW;" $verbose "$merged_file" < WhatsApp_DB_Merger.sql
echo "Done."
