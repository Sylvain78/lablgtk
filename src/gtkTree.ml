(* $Id$ *)

open Misc
open Gtk
open Tags
open GtkBase

module TreeItem = struct
  let cast w : tree_item obj = Object.try_cast w "GtkTreeItem"
  external create : unit -> tree_item obj = "ml_gtk_tree_item_new"
  external create_with_label : string -> tree_item obj
      = "ml_gtk_tree_item_new_with_label"
  let create ?label () =
    match label with None -> create ()
    | Some label -> create_with_label label
  external set_subtree : [>`treeitem] obj -> [>`widget] obj -> unit
      = "ml_gtk_tree_item_set_subtree"
  external remove_subtree : [>`treeitem] obj -> unit
      = "ml_gtk_tree_item_remove_subtree"
  external expand : [>`treeitem] obj -> unit
      = "ml_gtk_tree_item_expand"
  external collapse : [>`treeitem] obj -> unit
      = "ml_gtk_tree_item_collapse"
  external subtree : [>`treeitem] obj -> tree obj
      = "ml_GTK_TREE_ITEM_SUBTREE"
  let subtree t = try subtree t with Misc.Null_pointer -> raise Not_found
  module Signals = struct
    open GtkSignal
    let expand : ([>`treeitem],_) t =
      { name = "expand"; marshaller = marshal_unit }
    let collapse : ([>`treeitem],_) t =
      { name = "collapse"; marshaller = marshal_unit }
  end
end

module Tree = struct
  let cast w : tree obj = Object.try_cast w "GtkTree"
  external coerce : [>`tree] obj -> tree obj = "%identity"
  external create : unit -> tree obj = "ml_gtk_tree_new"
  external insert : [>`tree] obj -> [>`treeitem] obj -> pos:int -> unit
      = "ml_gtk_tree_insert"
  external remove_items : [>`tree] obj -> [>`treeitem] obj list -> unit
      = "ml_gtk_tree_remove_items"
  external clear_items : [>`tree] obj -> start:int -> stop:int -> unit
      = "ml_gtk_tree_clear_items"
  external select_item : [>`tree] obj -> pos:int -> unit
      = "ml_gtk_tree_select_item"
  external unselect_item : [>`tree] obj -> pos:int -> unit
      = "ml_gtk_tree_unselect_item"
  external child_position : [>`tree] obj -> [>`treeitem] obj -> int
      = "ml_gtk_tree_child_position"
  external set_selection_mode : [>`tree] obj -> selection_mode -> unit
      = "ml_gtk_tree_set_selection_mode"
  external set_view_mode : [>`tree] obj -> [`LINE|`ITEM] -> unit
      = "ml_gtk_tree_set_view_mode"
  external set_view_lines : [>`tree] obj -> bool -> unit
      = "ml_gtk_tree_set_view_lines"
  external selection : [>`tree] obj -> tree_item obj list =
    "ml_gtk_tree_selection"
  let set ?selection_mode ?view_mode ?view_lines w =
    let may_set f = may ~f:(f w) in
    may_set set_selection_mode selection_mode;
    may_set set_view_mode view_mode;
    may_set set_view_lines view_lines
  module Signals = struct
    open GtkSignal
    let selection_changed : ([>`tree],_) t =
      { name = "selection_changed"; marshaller = marshal_unit }
    let select_child : ([>`tree],_) t =
      { name = "select_child"; marshaller = Widget.Signals.marshal }
    let unselect_child : ([>`tree],_) t =
      { name = "unselect_child"; marshaller = Widget.Signals.marshal }
  end
end
