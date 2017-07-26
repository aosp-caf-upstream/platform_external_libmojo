# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

include common.mk

PC_DEPS = libchrome-$(BASE_VER)
PC_CFLAGS := $(shell $(PKG_CONFIG) --cflags $(PC_DEPS))
PC_LIBS := $(shell $(PKG_CONFIG) --libs $(PC_DEPS))

CPPFLAGS += -Wno-unused-parameter -Wno-missing-field-initializers $(PC_CFLAGS) -I$(OUT)

CXXFLAGS += -std=c++11 \
	-Wno-sign-promo \
	-Wno-non-virtual-dtor \
	-Wno-ignored-qualifiers \
	-Wno-format-nonliteral \
	-Wno-extra \
	-Wno-deprecated-register \
	-Wno-char-subscripts \
	-DOS_POSIX \
	-DNO_TCMALLOC \

LDLIBS += $(PC_LIBS)

CXX_OBJECTS := \
	base/base_paths.o \
	base/debug/proc_maps_linux.o \
	base/path_service.o \
	base/unguessable_token.o \
	ipc/ipc_message.o \
	ipc/ipc_message_attachment.o \
	ipc/ipc_message_attachment_set.o \
	ipc/ipc_message_utils.o \
	ipc/ipc_mojo_handle_attachment.o \
	ipc/ipc_mojo_message_helper.o \
	ipc/ipc_mojo_param_traits.o \
	ipc/ipc_platform_file_attachment_posix.o \
	mojo/common/common_custom_types_struct_traits.o \
	mojo/edk/embedder/connection_params.o \
	mojo/edk/embedder/embedder.o \
	mojo/edk/embedder/entrypoints.o \
	mojo/edk/embedder/platform_channel_pair.o \
	mojo/edk/embedder/platform_channel_pair_posix.o \
	mojo/edk/embedder/platform_channel_utils_posix.o \
	mojo/edk/embedder/platform_handle.o \
	mojo/edk/embedder/platform_handle_utils_posix.o \
	mojo/edk/embedder/platform_shared_buffer.o \
	mojo/edk/system/awakable_list.o \
	mojo/edk/system/broker_host.o \
	mojo/edk/system/broker_posix.o \
	mojo/edk/system/channel.o \
	mojo/edk/system/channel_posix.o \
	mojo/edk/system/configuration.o \
	mojo/edk/system/core.o \
	mojo/edk/system/data_pipe_consumer_dispatcher.o \
	mojo/edk/system/data_pipe_control_message.o \
	mojo/edk/system/data_pipe_producer_dispatcher.o \
	mojo/edk/system/dispatcher.o \
	mojo/edk/system/handle_table.o \
	mojo/edk/system/mapping_table.o \
	mojo/edk/system/message_for_transit.o \
	mojo/edk/system/message_pipe_dispatcher.o \
	mojo/edk/system/node_channel.o \
	mojo/edk/system/node_controller.o \
	mojo/edk/system/platform_handle_dispatcher.o \
	mojo/edk/system/ports/event.o \
	mojo/edk/system/ports/message.o \
	mojo/edk/system/ports/message_queue.o \
	mojo/edk/system/ports/name.o \
	mojo/edk/system/ports/node.o \
	mojo/edk/system/ports/port.o \
	mojo/edk/system/ports/port_ref.o \
	mojo/edk/system/ports_message.o \
	mojo/edk/system/request_context.o \
	mojo/edk/system/shared_buffer_dispatcher.o \
	mojo/edk/system/wait_set_dispatcher.o \
	mojo/edk/system/waiter.o \
	mojo/edk/system/watcher.o \
	mojo/edk/system/watcher_set.o \
	mojo/public/c/system/thunks.o \
	mojo/public/cpp/bindings/lib/array_internal.o \
	mojo/public/cpp/bindings/lib/associated_group.o \
	mojo/public/cpp/bindings/lib/associated_group_controller.o \
	mojo/public/cpp/bindings/lib/connector.o \
	mojo/public/cpp/bindings/lib/control_message_handler.o \
	mojo/public/cpp/bindings/lib/control_message_proxy.o \
	mojo/public/cpp/bindings/lib/filter_chain.o \
	mojo/public/cpp/bindings/lib/fixed_buffer.o \
	mojo/public/cpp/bindings/lib/interface_endpoint_client.o \
	mojo/public/cpp/bindings/lib/message.o \
	mojo/public/cpp/bindings/lib/message_buffer.o \
	mojo/public/cpp/bindings/lib/message_builder.o \
	mojo/public/cpp/bindings/lib/message_header_validator.o \
	mojo/public/cpp/bindings/lib/multiplex_router.o \
	mojo/public/cpp/bindings/lib/native_struct.o \
	mojo/public/cpp/bindings/lib/native_struct_data.o \
	mojo/public/cpp/bindings/lib/native_struct_serialization.o \
	mojo/public/cpp/bindings/lib/pipe_control_message_handler.o \
	mojo/public/cpp/bindings/lib/pipe_control_message_proxy.o \
	mojo/public/cpp/bindings/lib/scoped_interface_endpoint_handle.o \
	mojo/public/cpp/bindings/lib/serialization_context.o \
	mojo/public/cpp/bindings/lib/sync_handle_registry.o \
	mojo/public/cpp/bindings/lib/sync_handle_watcher.o \
	mojo/public/cpp/bindings/lib/validation_context.o \
	mojo/public/cpp/bindings/lib/validation_errors.o \
	mojo/public/cpp/bindings/lib/validation_util.o \
	mojo/public/cpp/system/platform_handle.o \
	mojo/public/cpp/system/watcher.o

MOJOM_FILES := ipc/ipc.mojom \
	mojo/common/file.mojom \
	mojo/common/string16.mojom \
	mojo/common/text_direction.mojom \
	mojo/common/time.mojom \
	mojo/common/unguessable_token.mojom \
	mojo/common/version.mojom \
	mojo/public/interfaces/bindings/pipe_control_messages.mojom \
	mojo/public/interfaces/bindings/interface_control_messages.mojom \

MOJOM_BINDINGS_GENERATOR := \
	$(S)/mojo/public/tools/bindings/mojom_bindings_generator.py

GEN_TEMPLATES_DIR := $(S)/templates

gen_templates:
	@echo generate_mojo_templates: $(GEN_TEMPLATES_DIR)
	@rm -rf $(GEN_TEMPLATES_DIR)
	@mkdir -p $(GEN_TEMPLATES_DIR)
	@python $(MOJOM_BINDINGS_GENERATOR) --use_bundled_pylibs precompile \
		-o $(GEN_TEMPLATES_DIR)

templates: gen_templates
	cd $(S) && \
		python $(abspath $(MOJOM_BINDINGS_GENERATOR)) \
		--use_bundled_pylibs generate \
		$(MOJOM_FILES) \
		-o $(abspath $(S)) \
		--bytecode_path $(abspath $(GEN_TEMPLATES_DIR)) \
		-g c++
	cd $(S) && \
		python $(abspath $(MOJOM_BINDINGS_GENERATOR)) \
		--use_bundled_pylibs generate \
		$(MOJOM_FILES) \
		-o $(abspath $(S)) \
		--bytecode_path $(abspath $(GEN_TEMPLATES_DIR)) \
		--generate_non_variant_code \
		-g c++

GENERATED_OBJECTS := $(patsubst %.mojom,%.mojom.o,$(MOJOM_FILES))
GENERATED_SHARED_OBJECTS := $(patsubst %.mojom,%.mojom-shared.o,$(MOJOM_FILES))

$(eval $(call add_object_rules,$(GENERATED_OBJECTS),CXX,cc,CXXFLAGS,$(SRC)/))
$(eval $(call add_object_rules,$(GENERATED_SHARED_OBJECTS),CXX,cc,CXXFLAGS,$(SRC)/))
# Note: I don't know why we need the line below (it's in commmon.mk), but without it,
# .o files from CXX_OBJECTS won't be built.
$(eval $(call add_object_rules,$(CXX_OBJECTS),CXX,cc,CXXFLAGS,$(SRC)/))

LIB ?= lib
LIB_PIE_NAME = libmojo-$(BASE_VER).pie.a
LIB_PIC_NAME = libmojo-$(BASE_VER).pic.a

CXX_STATIC_LIBRARY($(LIB_PIE_NAME)): $(GENERATED_SHARED_OBJECTS) $(GENERATED_OBJECTS) $(CXX_OBJECTS)
CXX_STATIC_LIBRARY($(LIB_PIC_NAME)): $(GENERATED_SHARED_OBJECTS) $(GENERATED_OBJECTS) $(CXX_OBJECTS)

all: CXX_STATIC_LIBRARY($(LIB_PIE_NAME)) CXX_STATIC_LIBRARY($(LIB_PIC_NAME))

clean: CLEAN($(LIB_PIE_NAME)) CLEAN($(LIB_PIC_NAME))

install_lib: all
	install -D -m 755 $(OUT)/$(LIB_PIE_NAME) $(DESTDIR)/usr/$(LIB)/$(LIB_PIE_NAME)
	install -D -m 755 $(OUT)/$(LIB_PIC_NAME) $(DESTDIR)/usr/$(LIB)/$(LIB_PIC_NAME)
	sed -e "s:@LIB@:$(LIB):g" -e "s:@BSLOT@:$(BASE_VER):g" $(S)/libmojo.pc.in > $(S)/libmojo-$(BASE_VER).pc

install_tool:
	install -d $(DESTDIR)/usr/src/libmojo-$(BASE_VER)/mojo/
	cp -r --preserve=mode $(SRC)/third_party $(DESTDIR)/usr/src/libmojo-$(BASE_VER)/
	cp -r --preserve=mode $(SRC)/mojo/public/tools/bindings/* \
		$(DESTDIR)/usr/src/libmojo-$(BASE_VER)/mojo/

install: install_lib install_tool
