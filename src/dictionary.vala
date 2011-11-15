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

class Rikai.Dictionary : GLib.Object {
	private Database db;

	public Dictionary(string path) {
		var rc = Database.open(path, out db);
	}

	public static string locate_dictionary() {
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
			return dict_path;
		} catch (KeyFileError err) {
			// TODO raise error
			return "kfe";
		} catch (FileError err) {
			return "fe";
		}
	}
}
