{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mtools-4.0.20";

  src = fetchurl {
    url = "mirror://gnu/mtools/${name}.tar.bz2";
    sha256 = "1vcahr9s6zv1hnrx2bgjnzcas2y951q90r1jvvv4q9v5kwfd6qb0";
  };

  # Prevents errors such as "mainloop.c:89:15: error: expected ')'"
  # Upstream issue https://lists.gnu.org/archive/html/info-mtools/2014-02/msg00000.html
  patches = [ ./fix-dos_to_wchar-declaration.patch ] ++
    stdenv.lib.optional stdenv.isDarwin ./UNUSED-darwin.patch;

  # fails to find X on darwin
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--without-x";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = http://www.gnu.org/software/mtools/;
    description = "Utilities to access MS-DOS disks";
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}
