package doc

import (
	"alpha.dagger.io/dagger"
	"alpha.dagger.io/docker"
)

// Docker registry
registry: {
	// Registry account username
	username: dagger.#Input & {string}
	// Registry account password or token
	secret: dagger.#Input & {dagger.#Secret}
}

// Repository
// (e.g dagger input dir repo myfolder/)
repo: dagger.#Input & {dagger.#Artifact}

// Publish documentaiton
doc: {
	// Generate a tag
	tag: dagger.#Input & {*"latest" | string}

	// Target repository (e.g daggercio/ci-test)
	target: dagger.#Input & {dagger.#Secret}

	// Build image
	image: docker.#Build & {
		source: repo
	}

	// Push image to remote registry
	remoteImage: docker.#Push & {
		"target": "\(target):\(tag)"
		source:   image
		auth: {
			username: registry.username
			secret:   registry.secret
		}
	}
}