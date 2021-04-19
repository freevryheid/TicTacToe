using Gtk;

public class
TTT: Window
{
  private ToggleButton[,] btn = new ToggleButton[3, 3];
  private Grid grid;
  private bool first;
  private int counter;
  private int owins;
  private int xwins;

  public
  TTT(WindowType type = POPUP)
  {
    title = "TTT";
    window_position = WindowPosition.CENTER;
    resizable = false;
    destroy.connect(Gtk.main_quit);
    set_default_size(128, 128);
    grid = new Grid();
    grid.column_homogeneous = true;
    grid.row_homogeneous = true;
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        btn[i, j] = new ToggleButton.with_label("");
        btn[i, j].toggled.connect(on_button_toggled);
        grid.attach(btn[i, j], i, j);
      }
    }
    add(grid);
    first = true;
    counter = 0;
  }

  private void
  new_game()
  {
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        btn[i, j].sensitive = true;
        btn[i, j].label = "";
        btn[i, j].toggled.disconnect(on_button_toggled);
        btn[i, j].active = false;
        btn[i, j].toggled.connect(on_button_toggled);
      }
    }
    counter = 0;
    if (!first)
    {
      ai();
    }
  }

  private int[]
  loc(ToggleButton ibtn)
  {
    Value left = 0;
    Value top = 0;
    int i, j;
    var parent = ibtn.parent;
    parent.child_get_property(ibtn, "left-attach", ref left);
    i = (int)left;
    parent.child_get_property(ibtn, "top-attach", ref top);
    j = (int)top;
    return {i, j};
  }

  private void
  ai()
  {
    while (true)
    {
      var i = Random.int_range(0, 3);
      var j = Random.int_range(0, 3);
      if (btn[i, j].active == false)
      {
        btn[i, j].active = true;
        break;
      }
    }
  }

  private void
  on_button_toggled(ToggleButton ibtn)
  {
    int i, j;
    (i, j) = loc(ibtn);
    ibtn.label = first ? "O" : "X";
    ibtn.sensitive = false;
    first = ! first;
    counter++;
    var w = win(i, j);
    if (w == "O") owins++;
    if (w == "X") xwins++;
    title = owins.to_string() + " : " + xwins.to_string();
    if (w.length > 0)
    {
      message(w + " wins! Play again?");
      return;
    }
    if (counter == 9)
    {
      message("Stalemate. Play again?");
      return;
    }
    if (! first)
    {
      ai();
    }
  }

  private string
  win(int i, int j)
  {
    string result;
    if ((btn[i, j].label == btn[i, (j+1)%3].label)
     && (btn[i, j].label == btn[i, (j+2)%3].label))
    {
      result = btn[i, j].label;
      btn[i, j].label = "T";
      btn[i, (j+1)%3].label = "T";
      btn[i, (j+2)%3].label = "T";
    }
    else if ((btn[i, j].label == btn[(i+1)%3, j].label)
          && (btn[i, j].label == btn[(i+2)%3, j].label))
    {
      result = btn[i, j].label;
      btn[i, j].label = "T";
      btn[(i+1)%3, j].label = "T";
      btn[(i+2)%3, j].label = "T";
    }
    else if ((i == j) && (btn[i, j].label == btn[(i+1)%3, (j+1)%3].label)
                      && (btn[i, j].label == btn[(i+2)%3, (j+2)%3].label))
    {
      result = btn[i, j].label;
      btn[i, j].label = "T";
      btn[(i+1)%3, (j+1)%3].label = "T";
      btn[(i+2)%3, (j+2)%3].label = "T";
    }
    else if ((i+j == 2) && (btn[i, j].label == btn[(i+2)%3, (j+1)%3].label)
                        && (btn[i, j].label == btn[(i+1)%3, (j+2)%3].label))
    {
      result = btn[i, j].label;
      btn[i, j].label = "T";
      btn[(i+1)%3, (j+2)%3].label = "T";
      btn[(i+2)%3, (j+1)%3].label = "T";
   }
   else
   {
     return "";
   }
   return result;
  }

  private void
  dialog_response(Dialog dialog, int response_id)
  {
    switch (response_id)
    {
      case ResponseType.YES:
        new_game();
        break;
      case ResponseType.NO:
        destroy();
        break;
      case ResponseType.DELETE_EVENT:
        destroy();
        break;
    }
      dialog.destroy();
  }

  private void
  message(string msg)
  {
    var msgdiag = new MessageDialog(this,
                                    DialogFlags.DESTROY_WITH_PARENT,
                                    MessageType.QUESTION,
                                    ButtonsType.YES_NO,
                                    msg);
    msgdiag.response.connect(dialog_response);
    msgdiag.show();
  }

  public static int
  main (string[] args)
  {
    Gtk.init(ref args);
    var window = new TTT();
    window.show_all();
    Gtk.main();
    return 0;
  }
}
