local-bin-path: PH_WINHOME/.stack/bin

m4_ifelse(PH_SYSTEM, NIXOS,
nix:
  enable: true
,)

templates:
  params:
   author-name: CMCDragonkai
   author-email: roger.qiu@polyhack.io
   copyright: 'Copyright: (c) 2017 Roger Qiu'
   github-username: CMCDragonkai
