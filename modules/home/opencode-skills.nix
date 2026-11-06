{ inputs, ... }:
{
  # Keep supporting files alongside skills; exclude upstream drafts and deprecated skills.
  xdg.configFile."opencode/skills/mattpocock/engineering" = {
    source = "${inputs.mattpocock-skills}/skills/engineering";
    recursive = true;
  };
  xdg.configFile."opencode/skills/mattpocock/productivity" = {
    source = "${inputs.mattpocock-skills}/skills/productivity";
    recursive = true;
  };
}
