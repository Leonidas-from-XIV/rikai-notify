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
