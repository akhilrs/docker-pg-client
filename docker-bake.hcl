group "default" {
	targets = ["latest", "3.13", "3.12"]
}
target "common" {
	platforms = ["linux/amd64", "linux/arm64"]
}

target "latest" {
	inherits = ["alpine"]
	args = {"BASETAG" = "latest"}
	tags = [
		"akhilrs/pg-client:alpine",
		"akhilrs/pg-client:latest"
	]
}
target "3.13" {
	inherits = ["alpine"]
	args = {"BASETAG" = "3.13"}
	tags = [
		"akhilrs/pg-client:3.13"
	]
}
target "3.12" {
	inherits = ["alpine"]
	args = {"BASETAG" = "3.12"}
	tags = [
		"akhilrs/pg-client:3.12"
	]
}
