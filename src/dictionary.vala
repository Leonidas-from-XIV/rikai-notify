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
using Gtk;

public class JMDict.Dictionary : GLib.Object {
	private Database db;
	public static Clipboard clip;
	public static string text;

	public Dictionary(string path) {
		int rc;

		rc = Database.open(path, out db);
	}

	public static void clipboard_changed() {
		stdout.printf("Called\n");
		text = clip.wait_for_text();
		if (text != null) {
			if ((text.get_char() >=  0x4E00 && text.get_char() <= 0x9FAF) ||
				(text.get_char() >=  0x30A0  && text.get_char() <= 0x30FF) ||
				(text.get_char() >= 0x3040 && text.get_char() <= 0x309F)) {
				stdout.printf(text);
				stdout.printf("\n");
			}
		}
	}

	public static int main(string[] args) {
		Gtk.init(ref args);
		stdout.printf("Hello world\n");
		var dictionary = new Dictionary("/usr/share/tagainijisho/jmdict-en.db");

		clip = Clipboard.get(Gdk.Atom.intern("PRIMARY", false));
		Signal.connect(clip, "owner_change", clipboard_changed, null);
		Gtk.main();

		return 0;
	}
}
