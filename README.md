# WhatsApp_DB_Merger
An SQLite3 script which merges two backup WhatsApp databases so that the messages can be viewed in linear history. Duplicate table entries are ignored.

## Prerequisites
BASH, SQLite v3

## Details
The following tables are merged:

|          Table             |      Key       |
| -------------------------- |:--------------:|
| messages                   | _id            |
| messages_links             | _id            |
| messages_quotes            | _id            |
| messages_vcards            | _id            |
| messages_vcards_jids       | _id            |
| media_refs                 | _id            |
| media_streaming_sidecar    | _id            |
| receipts                   | _id            |
| group_participants_history | _id            |
| message_thumbnails         | key_id         |
| chat_list                  | key_remote_jid |

Firstly, in the resulting database the tables listed above are created.
Then the "old" database is copied into the resulting database.
After that, for each table in the "new" database, all entries are scanned for key values which DO NOT exist in the "old" table.
These entries are merged into the tables in the resulting database.
This allows to skip duplicate table entries during merging.

The merged database can be used with the ["WhatsApp Viewer.exe"](http://andreas-mausch.de/whatsapp-viewer/) GUI application (runs on Linux under Wine) to view the stored chats.
Table "messages_fts" is not processed since its content is the same as the content of "messages".
Hence, size of the resulting database will be smaller than the total size of the input databases.

## Usage
Help invocation:

	./WhatsApp_DB_Merger.sh -h

To merge two databases:

	chmod +x WhatsApp_DB_Merger.sh
	./WhatsApp_DB_Merger.sh -o msgstore_2016_backup.db -n msgstore_2017_backup.db -m msgstore_2016_2017_backup.db

Options:

	-o  old database
	-n  new database
	-m  resulting (merged) database

## License
This project is licensed under the GPL v2.0 license.

## Author
Altynbek Isabekov
E-mail: aisabekov@ku.edu.tr
