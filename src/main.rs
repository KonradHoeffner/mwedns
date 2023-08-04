use std::net::ToSocketAddrs;

fn main() {
    let domains = ["google.com", "github.com"];
    for domain in domains
    {
        println!("Trying to resolve {domain} with to_socket_addrs()");
        format!("{domain}:443").to_socket_addrs().unwrap();
        println!("it worked");
        println!("Trying to get {domain} with ureq");
        ureq::get(&format!("https://{domain}")).call().unwrap().into_reader();
        println!("it worked");
    }
}
