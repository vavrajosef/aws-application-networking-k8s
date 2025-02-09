package integration

import (
	"context"
	"testing"

	"github.com/aws/aws-application-networking-k8s/test/pkg/test"
	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var testFramework *test.Framework
var ctx context.Context

func TestIntegration(t *testing.T) {
	ctx = test.NewContext(t)
	testFramework = test.NewFramework(ctx)
	RegisterFailHandler(Fail)
	RunSpecs(t, "Integration")
}
