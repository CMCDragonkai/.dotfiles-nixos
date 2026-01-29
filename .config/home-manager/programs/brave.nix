{ ... }:

{
  programs.brave = {
    enable = true;
    extensions = [
      {
        # Vimium
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      }
      {
        # LastPass
        id = "hdokiejnpimakedhajhdlcegeplioahd";
      }
      {
        # React-Developer-Tools
        id = "fmkadmapgofadopljbjfkapdkoienihi";
      }
      {
        # ChatGPT Exporter
        id = "ilmdofdhpnhffldihboadndccenlnfll";
      }
      {
        # SVG Navigator
        id = "pefngfjmidahdaahgehodmfodhhhofkl";
      }
      {
        # FoxyProxy
        id = "gcknhkkoolaabfmlnjonogaaifnjlfnp";
      }
    ];
  };
}