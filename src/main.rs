use std::net::ToSocketAddrs;

fn main() {
    let domains = ["google.com", "github.com"];
    for domain in domains
    {
        println!("Trying to resolve {domain} with to_socket_addrs()");
        format!("{domain}:443").to_socket_addrs().unwrap();
        println!("it worked");
    }
}
