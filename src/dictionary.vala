/*
    Copyright (C) 2011  Marek Kubica

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using Sqlite;

errordomain LocationError {
	CONFIG_MISSING,
	INVALID_CONFIG
}

errordomain Rikai.DatabaseError {
	INVALID_DATABASE
}

errordomain Rikai.LookupError {
	NO_SUCH_ENTRY,
	DATABASE_FAILURE
}

class Rikai.Dictionary : GLib.Object {
	private Database db;

	public Dictionary(string path) throws DatabaseError {
		if (Database.open(path, out db) != Sqlite.OK) {
			throw new DatabaseError.INVALID_DATABASE(
				"SQLite database cannot be opened");
		}
	}

	public string look_up(string phrase) throws LookupError {
		Statement stmt;
		var sql = """SELECT entry FROM dict WHERE kana LIKE ?1 OR kanji LIKE ?1 LIMIT 1""";
		if (db.prepare_v2(sql, -1, out stmt) != Sqlite.OK) {
			throw new LookupError.DATABASE_FAILURE("Error preparing.");
		}
		if (stmt.bind_text(1, phrase, -1) != Sqlite.OK) {
			throw new LookupError.DATABASE_FAILURE("Error binding.");
		}
		var success = stmt.step();
		if (success != Sqlite.ROW && success != Sqlite.DONE) {
			throw new LookupError.DATABASE_FAILURE("Error stepping.");
		}
		var l = stmt.column_text(0);
		stmt.reset();
		if (l == null) {
			// TODO: format the phrase in
			throw new LookupError.NO_SUCH_ENTRY("No matches");
		}
		return l;
	}

	public static string locate_dictionary() throws LocationError {
		var home = GLib.Environment.get_home_dir();
		var ff_path = GLib.Path.build_path(GLib.Path.DIR_SEPARATOR_S, home,
			".mozilla", "firefox");
		var conf_path = GLib.Path.build_filename(ff_path, "profiles.ini");
		var kf = new KeyFile();
		try {
			kf.load_from_file(conf_path, KeyFileFlags.NONE);
			var variable_part = kf.get_string("Profile0", "Path");
			var dict_path = GLib.Path.build_filename(ff_path,
				variable_part, "extensions",
				"rikaichan-jpen@polarcloud.com", "dict.sqlite");
			// TODO check existance & raise error
			return dict_path;
		} catch (KeyFileError err) {
			throw new LocationError.INVALID_CONFIG(
				"Firefox configuration file invalid");
		} catch (FileError err) {
			throw new LocationError.CONFIG_MISSING(
				"No Firefox profile found");
		}
	}
}
