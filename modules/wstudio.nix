{ inputs, ... }:
{
  flake.homeModules.wstudio = _: {
    imports = [ inputs.wstudio.homeManagerModules.default ];

    programs.wstudio = {
      enable = true;
      settings = {
        preferred_frontend = "tui";
        default_tempo = 120.0;
        default_sample_rate = 48000;
        default_beats_per_bar = 4;
        default_octave = 4;
        default_velocity = 0.85;
        autosave_interval_s = 30;
        frame_poll_ms = 30;
        audio_block_frames = 256;
        audio_backend = "auto";
        tap_timeout_ms = 2000;
        note_preview_ms = 220;
        cmd_history_lines = 50;
        status_message_ms = 3000;
        default_browse_dir = "";
        default_project_path = "project.wsj";
        file_browser_show_hidden = false;
        default_drum_grid = "sixteenth";
        default_piano_grid = "sixteenth";
        default_piano_triplet_grid = false;
        default_piano_note_length_steps = 1;
        default_arrangement_grid = "quarter";
        piano_ghost_notes = false;
        tui_mouse = true;
        tui_theme = "none";
        gui_font_size = 15.0;
        gui_vsync = true;
        gui_theme = "patina";
        gui_window_width = 1440;
        gui_window_height = 900;
      };
    };
  };
}
