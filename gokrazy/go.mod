module github.com/mdlayher/homelab/gokrazy

go 1.14

require (
	github.com/creack/pty v1.1.11 // indirect
	github.com/ema/qdisc v0.0.0-20200603082823-62d0308e3e00 // indirect
	github.com/gokrazy/breakglass v0.0.0-20200527163858-efff2172eebe
	github.com/gokrazy/firmware v0.0.0-20200713142910-9f312dfad72f
	github.com/gokrazy/gokrazy v0.0.0-20200629220445-6739b590288a
	github.com/gokrazy/internal v0.0.0-20200713084155-ab6fc6e02a03 // indirect
	github.com/gokrazy/kernel v0.0.0-20200713073858-5a6073ec9475
	github.com/gokrazy/rpi-eeprom v0.0.0-20200618184116-4854011f5f17
	github.com/gokrazy/stat v0.1.0
	github.com/google/shlex v0.0.0-20191202100458-e7afc7fbc510 // indirect
	github.com/mdlayher/consrv v0.0.0-20200713134219-99324c7b5234
	github.com/mdlayher/wifi v0.0.0-20200527114002-84f0b9457fdd // indirect
	github.com/prometheus/node_exporter v1.0.1
	golang.org/x/crypto v0.0.0-20200709230013-948cd5f35899 // indirect
	golang.org/x/net v0.0.0-20200707034311-ab3426394381 // indirect
	golang.org/x/text v0.3.3 // indirect
)

replace github.com/gokrazy/gokrazy => /home/matt/src/github.com/gokrazy/gokrazy
