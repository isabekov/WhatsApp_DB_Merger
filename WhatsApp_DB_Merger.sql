-- WhatsApp_DB_Merger.sql
-- A script which merges an old WhatsApp database "OLD" with the new database "NEW" into a resulting database.
-- Duplicate table entries are ignored during merging.
-- Databases "OLD" and "NEW" should be attached externally, example use of the script:
-- `sqlite3 -cmd 'ATTACH DATABASE "msgstore_old.db" AS OLD; ATTACH DATABASE "msgstore_new.db" AS NEW;' Merged.db < WhatsApp_DB_Merger.sql`
-- The merged database can be used with the "WhatsApp Viewer.exe" GUI application (runs on Linux under Wine) to view the stored chats.
-- License: GPL v2.0
-- Author: Altynbek Isabekov
-- E-mail: aisabekov@ku.edu.tr

.databases
.tables
DROP TABLE IF EXISTS main.messages;
DROP TABLE IF EXISTS main.messages_links;
DROP TABLE IF EXISTS main.messages_quotes;
DROP TABLE IF EXISTS main.messages_vcards;
DROP TABLE IF EXISTS main.messages_vcards_jids;
DROP TABLE IF EXISTS main.message_thumbnails;
DROP TABLE IF EXISTS main.chat_list;
DROP TABLE IF EXISTS main.receipts;
DROP TABLE IF EXISTS main.media_refs;
DROP TABLE IF EXISTS main.media_streaming_sidecar;
DROP TABLE IF EXISTS main.group_participants_history;
.tables
------------------------------------------------------------------------
----------------------------- messages ---------------------------------
------------------------------------------------------------------------
CREATE TABLE main.messages (_id INTEGER PRIMARY KEY AUTOINCREMENT, key_remote_jid TEXT NOT NULL, key_from_me INTEGER, key_id TEXT NOT NULL, status INTEGER, needs_push INTEGER, data TEXT, timestamp INTEGER, media_url TEXT, media_mime_type TEXT, media_wa_type TEXT, media_size INTEGER, media_name TEXT, media_caption TEXT, media_hash TEXT, media_duration INTEGER, origin INTEGER, latitude REAL, longitude REAL, thumb_image TEXT, remote_resource TEXT, received_timestamp INTEGER, send_timestamp INTEGER, receipt_server_timestamp INTEGER, receipt_device_timestamp INTEGER, read_device_timestamp INTEGER, played_device_timestamp INTEGER, raw_data BLOB, recipient_count INTEGER, participant_hash TEXT, starred INTEGER, quoted_row_id INTEGER, mentioned_jids TEXT, multicast_id TEXT, edit_version INTEGER, media_enc_hash TEXT, payment_transaction_id TEXT);

INSERT INTO main.messages
(_id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id)
SELECT _id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id
FROM OLD.messages;

INSERT INTO main.messages
(_id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id)
SELECT _id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id
FROM NEW.messages
WHERE NEW.messages._id IN 
(SELECT NEW.messages._id FROM NEW.messages
LEFT OUTER JOIN OLD.messages
ON NEW.messages._id = OLD.messages._id
WHERE OLD.messages._id IS null);

------------------------------------------------------------------------
----------------------------- chat_list --------------------------------
------------------------------------------------------------------------
-- key_remote_jid should be unique!

CREATE TABLE main.chat_list (_id INTEGER PRIMARY KEY AUTOINCREMENT, key_remote_jid TEXT UNIQUE, message_table_id INTEGER, subject TEXT, creation INTEGER, last_read_message_table_id INTEGER, last_read_receipt_sent_message_table_id INTEGER, archived INTEGER, sort_timestamp INTEGER, mod_tag INTEGER, gen REAL, my_messages INTEGER, plaintext_disabled BOOLEAN, last_message_table_id INTEGER, unseen_message_count INTEGER, unseen_missed_calls_count INTEGER, unseen_row_count INTEGER, vcard_ui_dismissed INTEGER, deleted_message_id INTEGER, deleted_starred_message_id INTEGER, deleted_message_categories TEXT, change_number_notified_message_id INTEGER);

INSERT INTO main.chat_list
(_id, key_remote_jid, message_table_id, subject, creation, last_read_message_table_id, last_read_receipt_sent_message_table_id, archived, sort_timestamp, mod_tag, gen, my_messages, plaintext_disabled, last_message_table_id, unseen_message_count, unseen_missed_calls_count, unseen_row_count, vcard_ui_dismissed, deleted_message_id, deleted_starred_message_id, deleted_message_categories, change_number_notified_message_id)
SELECT _id, key_remote_jid, message_table_id, subject, creation, last_read_message_table_id, last_read_receipt_sent_message_table_id, archived, sort_timestamp, mod_tag, gen, my_messages, plaintext_disabled, last_message_table_id, unseen_message_count, unseen_missed_calls_count, unseen_row_count, vcard_ui_dismissed, deleted_message_id, deleted_starred_message_id, deleted_message_categories, change_number_notified_message_id
FROM OLD.chat_list;

INSERT INTO main.chat_list
(_id, key_remote_jid, message_table_id, subject, creation, last_read_message_table_id, last_read_receipt_sent_message_table_id, archived, sort_timestamp, mod_tag, gen, my_messages, plaintext_disabled, last_message_table_id, unseen_message_count, unseen_missed_calls_count, unseen_row_count, vcard_ui_dismissed, deleted_message_id, deleted_starred_message_id, deleted_message_categories, change_number_notified_message_id)
SELECT _id, key_remote_jid, message_table_id, subject, creation, last_read_message_table_id, last_read_receipt_sent_message_table_id, archived, sort_timestamp, mod_tag, gen, my_messages, plaintext_disabled, last_message_table_id, unseen_message_count, unseen_missed_calls_count, unseen_row_count, vcard_ui_dismissed, deleted_message_id, deleted_starred_message_id, deleted_message_categories, change_number_notified_message_id
FROM NEW.chat_list
WHERE NEW.chat_list.key_remote_jid IN 
(SELECT NEW.chat_list.key_remote_jid FROM NEW.chat_list
LEFT OUTER JOIN OLD.chat_list
ON NEW.chat_list.key_remote_jid = OLD.chat_list.key_remote_jid
WHERE OLD.chat_list._id IS null);

-------------------------------------------------------------------------------
--------------------------------- media_refs ----------------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.media_refs (_id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT UNIQUE, ref_count INTEGER);

INSERT INTO main.media_refs
(_id, path, ref_count)
SELECT _id, path, ref_count
FROM OLD.media_refs;

INSERT INTO main.media_refs
(_id, path, ref_count)
SELECT _id, path, ref_count
FROM NEW.media_refs
WHERE NEW.media_refs._id IN 
(SELECT NEW.media_refs._id FROM NEW.media_refs
LEFT OUTER JOIN OLD.media_refs
ON NEW.media_refs._id = OLD.media_refs._id
WHERE OLD.media_refs._id IS null);

-------------------------------------------------------------------------------
----------------------------- media_streaming_sidecar -------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.media_streaming_sidecar (_id INTEGER PRIMARY KEY AUTOINCREMENT, sidecar BLOB, key_remote_jid TEXT NOT NULL, key_from_me INTEGER, key_id TEXT NOT NULL, timestamp datetime);

INSERT INTO main.media_streaming_sidecar
(_id, sidecar, key_remote_jid, key_from_me, key_id, timestamp)
SELECT _id, sidecar, key_remote_jid, key_from_me, key_id, timestamp
FROM OLD.media_streaming_sidecar;

INSERT INTO main.media_streaming_sidecar
(_id, sidecar, key_remote_jid, key_from_me, key_id, timestamp)
SELECT _id, sidecar, key_remote_jid, key_from_me, key_id, timestamp
FROM NEW.media_streaming_sidecar
WHERE NEW.media_streaming_sidecar._id IN 
(SELECT NEW.media_streaming_sidecar._id FROM NEW.media_streaming_sidecar
LEFT OUTER JOIN OLD.media_streaming_sidecar
ON NEW.media_streaming_sidecar._id = OLD.media_streaming_sidecar._id
WHERE OLD.media_streaming_sidecar._id IS null);

-------------------------------------------------------------------------------
----------------------------- message_thumbnails ------------------------------
-------------------------------------------------------------------------------
---------- Contains thumbnails of the sent/received images in JPEG format
CREATE TABLE main.message_thumbnails (thumbnail BLOB, timestamp DATETIME, key_remote_jid TEXT NOT NULL, key_from_me INTEGER, key_id TEXT NOT NULL);

INSERT INTO main.message_thumbnails
(thumbnail, timestamp, key_remote_jid, key_from_me, key_id)
SELECT thumbnail, timestamp, key_remote_jid, key_from_me, key_id
FROM OLD.message_thumbnails;

INSERT INTO main.message_thumbnails
(thumbnail, timestamp, key_remote_jid, key_from_me, key_id)
SELECT thumbnail, timestamp, key_remote_jid, key_from_me, key_id
FROM NEW.message_thumbnails
WHERE NEW.message_thumbnails.key_id IN 
(SELECT NEW.message_thumbnails.key_id FROM NEW.message_thumbnails
LEFT OUTER JOIN OLD.message_thumbnails
ON NEW.message_thumbnails.key_id = OLD.message_thumbnails.key_id
WHERE OLD.message_thumbnails.key_id IS null);

-------------------------------------------------------------------------------
----------------------------- message_links -----------------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.messages_links (_id INTEGER PRIMARY KEY AUTOINCREMENT, key_remote_jid TEXT, message_row_id INTEGER, link_index INTEGER);

INSERT INTO main.messages_links
(_id, key_remote_jid, message_row_id, link_index)
SELECT _id, key_remote_jid, message_row_id, link_index
FROM OLD.messages_links;

INSERT INTO main.messages_links
(_id, key_remote_jid, message_row_id, link_index)
SELECT _id, key_remote_jid, message_row_id, link_index
FROM NEW.messages_links
WHERE NEW.messages_links._id IN 
(SELECT NEW.messages_links._id FROM NEW.messages_links
LEFT OUTER JOIN OLD.messages_links
ON NEW.messages_links._id = OLD.messages_links._id
WHERE OLD.messages_links._id IS null);

-------------------------------------------------------------------------------
----------------------------- messages_quotes ---------------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.messages_quotes (_id INTEGER PRIMARY KEY AUTOINCREMENT, key_remote_jid TEXT NOT NULL, key_from_me INTEGER, key_id TEXT NOT NULL, status INTEGER, needs_push INTEGER, data TEXT, timestamp INTEGER, media_url TEXT, media_mime_type TEXT, media_wa_type TEXT, media_size INTEGER, media_name TEXT, media_caption TEXT, media_hash TEXT, media_duration INTEGER, origin INTEGER, latitude REAL, longitude REAL, thumb_image TEXT, remote_resource TEXT, received_timestamp INTEGER, send_timestamp INTEGER, receipt_server_timestamp INTEGER, receipt_device_timestamp INTEGER, read_device_timestamp INTEGER, played_device_timestamp INTEGER, raw_data BLOB, recipient_count INTEGER, participant_hash TEXT, starred INTEGER, quoted_row_id INTEGER, mentioned_jids TEXT, multicast_id TEXT, edit_version INTEGER, media_enc_hash TEXT, payment_transaction_id TEXT);

INSERT INTO main.messages_quotes
(_id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id)
SELECT _id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id
FROM OLD.messages_quotes;

INSERT INTO main.messages_quotes
(_id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id)
SELECT _id, key_remote_jid, key_from_me, key_id, status, needs_push, data, timestamp, media_url, media_mime_type, media_wa_type, media_size, media_name, media_caption, media_hash, media_duration, origin, latitude, longitude, thumb_image, remote_resource, received_timestamp, send_timestamp, receipt_server_timestamp, receipt_device_timestamp, read_device_timestamp, played_device_timestamp, raw_data, recipient_count, participant_hash, starred, quoted_row_id, mentioned_jids, multicast_id, edit_version, media_enc_hash, payment_transaction_id
FROM NEW.messages_quotes
WHERE NEW.messages_quotes._id IN 
(SELECT NEW.messages_quotes._id FROM NEW.messages_quotes
LEFT OUTER JOIN OLD.messages_quotes
ON NEW.messages_quotes._id = OLD.messages_quotes._id
WHERE OLD.messages_quotes._id IS null);

-------------------------------------------------------------------------------
----------------------------- messages_vcards ---------------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.messages_vcards (_id INTEGER PRIMARY KEY AUTOINCREMENT, message_row_id INTEGER, sender_jid TEXT, vcard TEXT, chat_jid TEXT);

INSERT INTO main.messages_vcards
(_id, message_row_id, sender_jid, vcard, chat_jid)
SELECT _id, message_row_id, sender_jid, vcard, chat_jid
FROM OLD.messages_vcards;

INSERT INTO main.messages_vcards
(_id, message_row_id, sender_jid, vcard, chat_jid)
SELECT _id, message_row_id, sender_jid, vcard, chat_jid
FROM NEW.messages_vcards
WHERE NEW.messages_vcards._id IN 
(SELECT NEW.messages_vcards._id FROM NEW.messages_vcards
LEFT OUTER JOIN OLD.messages_vcards
ON NEW.messages_vcards._id = OLD.messages_vcards._id
WHERE OLD.messages_vcards._id IS null);

-------------------------------------------------------------------------------
----------------------------- messages_vcards_jids ----------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.messages_vcards_jids (_id INTEGER PRIMARY KEY AUTOINCREMENT, message_row_id INTEGER, vcard_jid TEXT, vcard_row_id INTEGER);

INSERT INTO main.messages_vcards_jids
(_id, message_row_id, vcard_jid, vcard_row_id)
SELECT _id, message_row_id, vcard_jid, vcard_row_id
FROM OLD.messages_vcards_jids;

INSERT INTO main.messages_vcards_jids
(_id, message_row_id, vcard_jid, vcard_row_id)
SELECT _id, message_row_id, vcard_jid, vcard_row_id
FROM NEW.messages_vcards_jids
WHERE NEW.messages_vcards_jids._id IN 
(SELECT NEW.messages_vcards_jids._id FROM NEW.messages_vcards_jids
LEFT OUTER JOIN OLD.messages_vcards_jids
ON NEW.messages_vcards_jids._id = OLD.messages_vcards_jids._id
WHERE OLD.messages_vcards_jids._id IS null);

-------------------------------------------------------------------------------
--------------------------------- receipts ------------------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.receipts (_id INTEGER PRIMARY KEY AUTOINCREMENT, key_remote_jid TEXT NOT NULL, key_id TEXT NOT NULL, remote_resource TEXT, receipt_device_timestamp INTEGER, read_device_timestamp INTEGER, played_device_timestamp INTEGER);

INSERT INTO main.receipts
(_id, key_remote_jid, key_id, remote_resource, receipt_device_timestamp, read_device_timestamp, played_device_timestamp)
SELECT _id, key_remote_jid, key_id, remote_resource, receipt_device_timestamp, read_device_timestamp, played_device_timestamp
FROM OLD.receipts;

INSERT INTO main.receipts
(_id, key_remote_jid, key_id, remote_resource, receipt_device_timestamp, read_device_timestamp, played_device_timestamp)
SELECT _id, key_remote_jid, key_id, remote_resource, receipt_device_timestamp, read_device_timestamp, played_device_timestamp
FROM NEW.receipts
WHERE NEW.receipts._id IN 
(SELECT NEW.receipts._id FROM NEW.receipts
LEFT OUTER JOIN OLD.receipts
ON NEW.receipts._id = OLD.receipts._id
WHERE OLD.receipts._id IS null);

-------------------------------------------------------------------------------
-------------------------- group_participants_history -------------------------
-------------------------------------------------------------------------------
CREATE TABLE main.group_participants_history (_id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp DATETIME NOT NULL, gjid TEXT NOT NULL, jid TEXT NOT NULL, action INTEGER NOT NULL, old_phash TEXT NOT NULL, new_phash TEXT NOT NULL);

INSERT INTO main.group_participants_history
(_id, timestamp, gjid, jid, action, old_phash, new_phash)
SELECT _id, timestamp, gjid, jid, action, old_phash, new_phash
FROM OLD.group_participants_history;

INSERT INTO main.group_participants_history
(_id, timestamp, gjid, jid, action, old_phash, new_phash)
SELECT _id, timestamp, gjid, jid, action, old_phash, new_phash
FROM NEW.group_participants_history
WHERE NEW.group_participants_history._id IN 
(SELECT NEW.group_participants_history._id FROM NEW.group_participants_history
LEFT OUTER JOIN OLD.group_participants_history
ON NEW.group_participants_history._id = OLD.group_participants_history._id
WHERE OLD.group_participants_history._id IS null);
