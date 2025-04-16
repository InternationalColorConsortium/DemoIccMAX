#
## 
## Copyright (c) 2024-2025. David H Hoyt LLC. All rights reserved.
##
## Written by David Hoyt 
## Date: 28-MAR-2025 2000 EDT
#
# Branch: PR124
# Intent: logging.mk — Cross-platform logging & verbosity support for AFL tools
# Production: TRUE
# Runner: TRUE
#
#
# Updates: logging.mk — Cross-platform logging & verbosity support for AFL tools
#          
#
# 
# 
#  
# logging.mk — Cross-platform logging & verbosity support ripped from the SRD SDK

# VERBOSE=0 disables log output and echoing commands
export VERBOSE ?= 1
ifeq (0, ${VERBOSE})
.SILENT:
endif

# Silence output if VERBOSE=0
export _REDIRECT_OUTPUT := $(if $(filter 0,${VERBOSE}), > /dev/null,)
export EXTRA_MAKE_FLAGS := $(if $(filter 0,${VERBOSE}), -s,)

# Terminal detection
TERM_OK := $(shell [ -t 1 ] && echo yes)

# Color-safe `tput` wrappers — only use if terminal is interactive
ifeq ($(TERM_OK),yes)
	TPUT := tput -Txterm
else
	TPUT := echo
endif

# Safe color definitions
BLUE  := $(shell $(TPUT) setaf 6 2>/dev/null || echo "")
GREEN := $(shell $(TPUT) setaf 2 2>/dev/null || echo "")
WHITE := $(shell $(TPUT) setaf 7 2>/dev/null || echo "")
RED   := $(shell $(TPUT) setaf 1 2>/dev/null || echo "")
RESET := $(shell $(TPUT) sgr0    2>/dev/null || echo "")

# Fallback project name if PROJECT_NAME isn't set
export PROJECT_DISPLAY_NAME := $(or ${PROJECT_NAME}, $(notdir $(CURDIR)))

# Logging macro: $(call log, your message here)
log = @echo "${WHITE}[${PROJECT_DISPLAY_NAME}] - $(1)${RESET}"

# Phase logging macros
define log_download
$(call log, [%] Downloading dependencies)
endef

define log_configure
$(call log, [+] Configuring build)
endef

define log_build
$(call log, [++] Building sources)
endef

define log_install
$(call log, [+++] Installing binaries)
endef

define log_clean
$(call log, [---] Cleaning artifacts)
endef

define log_die
$(call log, [!!] ERROR: $(1))
	@exit 1
endef

define check_path
@command -v $(1) >/dev/null || ($(call log_die, $(2)))
endef
