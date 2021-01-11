package main

import (
    "net/http"
    "log"
    "fmt"
    "io"
	"os"
)

func main() {
    // fmt.Println("Usage: fs [port] [path]");
    args := os.Args;
    port := "2332";
    path := ".";
    if len(args) >= 3 {
        path = args[2];
    }
    if len(args) >= 2 {
        port = args[1];
    }
    fs := http.FileServer(http.Dir(path))
    http.Handle("/", httpH(fs))

    err := http.ListenAndServe(":" + port, nil)
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    } else {
		fmt.Printf("server on :%s\n", port);
	}
}

func httpH(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        log.Print(r.RemoteAddr, " ", r.URL)

        var (
            url   = r.URL.Path
            isDir = url[len(url)-1] == '/'
        )
        if isDir {
            io.WriteString(w, "<style>a{font-size: 32px; margin-left: 50%;}</style>")
        }
        next.ServeHTTP(w, r)
    })
}
