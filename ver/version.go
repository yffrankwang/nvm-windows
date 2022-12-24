package ver

import (
	"time"
)

// inject by go build
var (
	// Version app version
	Version string

	// Revision app revision
	Revision string

	// buildTime app build time
	buildTime string

	// BuildTime app build time
	BuildTime, _ = time.Parse("2006-01-02T15:04:05Z", buildTime)

	// NvmVersion
	NvmVersion = Version + "." + Revision + " (" + BuildTime.Format("2006-01-02 15:04:05") + ")"
)
