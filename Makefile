# The task runner is the source of truth for how this app is launched.
# See the `flutter-run` skill: a bare `flutter run` drifts between machines.

FLUTTER ?= flutter
PROJECT ?= agenda
ENV     ?= dev
PLATFORM ?= web
DEVICE  ?=

APP_DIR := apps/$(PROJECT)
SECRETS := .secrets.$(PROJECT).$(ENV).json

ifeq ($(ENV),prod)
  BASE_URL ?= https://api.example.com
  BUILD_MODE := --release
else
  BASE_URL ?= http://localhost:8080
  BUILD_MODE := --debug
endif

ifeq ($(PLATFORM),web)
  DEVICE_FLAG := -d chrome
else
  DEVICE_FLAG := $(if $(DEVICE),-d $(DEVICE),)
endif

# Every key in the secrets file reaches the app in one shot. Without the file
# we fall back to the two public defines and say so, loudly - a silent
# fallback produces an app that launches and then misbehaves.
ifneq ($(wildcard $(SECRETS)),)
  DEFINES := --dart-define-from-file=$(SECRETS)
else
  DEFINES := --dart-define=BASE_URL=$(BASE_URL) --dart-define=APP_NAME=$(PROJECT)
endif

.PHONY: help setup dev build analyze format test coverage clean secrets doctor

help: ## Show this help.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

setup: ## Resolve workspace dependencies.
	$(FLUTTER) pub get

secrets: ## Remind you where secrets come from (wire this to your secret manager).
	@echo "Generate $(SECRETS) from your secret manager, e.g.:"
	@echo "  doppler secrets download --no-file --format json > $(SECRETS)"
	@echo "It is gitignored. Never commit it."

dev: ## Run the app. PROJECT=agenda ENV=dev PLATFORM=web|android
ifeq ($(wildcard $(SECRETS)),)
	@echo "\033[33mWARNING: $(SECRETS) not found - running with fallback defines only.\033[0m"
	@echo "\033[33mRun 'make secrets' if a feature needs more than BASE_URL.\033[0m"
endif
	cd $(APP_DIR) && $(FLUTTER) run $(DEVICE_FLAG) $(DEFINES)

build: ## Build the app. ENV=prod for a release build.
	cd $(APP_DIR) && $(FLUTTER) build web $(BUILD_MODE) $(DEFINES)

analyze: ## Analyze every package.
	$(FLUTTER) analyze

format: ## Check formatting (fails if anything would change).
	dart format . --set-exit-if-changed

test: ## Run every test suite.
	cd packages/app_core && $(FLUTTER) test
	cd $(APP_DIR) && $(FLUTTER) test

coverage: ## Run tests with coverage for the core package.
	cd packages/app_core && $(FLUTTER) test --coverage

clean: ## Clean build output. Do this before believing a blank web page.
	$(FLUTTER) clean
	rm -rf $(APP_DIR)/build/web

doctor: ## Environment health.
	$(FLUTTER) doctor -v
