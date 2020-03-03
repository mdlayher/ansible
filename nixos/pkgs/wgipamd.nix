{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wgipamd";
  version = "0.1.0";

  goPackagePath = "github.com/mdlayher/wgipam";

  src = fetchFromGitHub {
    owner = "mdlayher";
    repo = "wgipam";
    rev = "v${version}";
    sha256 = "1kc4ynqxyg1qvwbs9lcwqmv9hczzjw195axfxi2mbvqy54z25za1";
  };

  modSha256 = "05nw4nfyml5r12qwh3kj1ml2njjwx12z471hlv5h51fb5f141iih";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mdlayher/wgipam";
    description =
      "IPAM daemon for dynamic IP address assignment to WireGuard peers, using the wg-dynamic protocol.";
    license = licenses.asl20;
    maintainers = with maintainers; [ mdlayher ];
  };
}
