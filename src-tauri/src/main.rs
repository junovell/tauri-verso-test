// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

// fn main() {
//     testo_lib::run()
// }


fn main() {
    // You can also set the `versoview` executable path yourself
    // tauri_runtime_verso::set_verso_path("../verso/target/debug/versoview");

    // To use the devtools, set it like to let verso open a devtools server,
    // and you can connect to it through Firefox's devtools in the `about:debugging` page
    tauri_runtime_verso::set_verso_devtools_port(1234);

    tauri_runtime_verso::builder()
        .invoke_handler(tauri::generate_handler![greet])
        .setup(|app| {
            dbg!(app.get_webview_window("main").unwrap().inner_size()).unwrap();
            Ok(())
        })
        .run(tauri::generate_context!())
        .expect("error while running tauri application")
}
