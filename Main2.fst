module Main2

type impl = | Impl1 | Impl2

let which_impl (): Tot impl =
  Impl1

let main () =
  match which_impl () with
  | Impl1 -> Impl1.f (); C.exit_success
  | Impl2 -> Impl2.f (); C.exit_success
