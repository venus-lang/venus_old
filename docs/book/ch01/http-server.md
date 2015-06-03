# Open a web server

# Code

```d
import std.net

main() {
	val server = createWebServer (
		host='localhost', // host of the webserver, when you open an online service, use 'www.example.com' and the like.
		root='.', // root directory of the webserver, where your static html files are located. default to current directory('.').
		port=8080 ) // port, default to 80
	server.start()
}
```

when the server is started, you can visit using a web browser,
type in the address 'http://localhost:8080/',

if your current directory has an index.html file, that page will be served an seen in the browser.

# Explain it

Here we can see a new language feature: parameter with names.

This feature is the same with Python: you can call a function specifying parameternames to make it more clear.


# One liner

```d
import std.net

main() {
	createWebServer('localhost').start()
}
```

using default root and port, creating a webserver is really easy.
