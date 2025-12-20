# Makefile for Android drawable icon generation

# Default source file (can be overridden with SOURCE=path/to/image.png)
SOURCE ?= icon.png

# Output filename (without extension, only .png supported)
NAME ?= ic_launcher

generate-icon:
	@echo "Generating Android drawable icons from $(SOURCE)"
	@echo "Scaling based on source image size (mdpi = original size)"
	@echo "Output name: $(NAME).png"
	@echo ""
	
	# Check if source file exists
	@if [ ! -f "$(SOURCE)" ]; then \
		echo "Error: Source file $(SOURCE) not found!"; \
		echo "Usage: make generate-icon SOURCE=path/to/your/image.png"; \
		exit 1; \
	fi
	
	# Check if ImageMagick is installed
	@which magick > /dev/null || (echo "Error: ImageMagick is not installed. Install it with: brew install imagemagick" && exit 1)
	
	# Check if any files with this name already exist and handle versioning
	@FINAL_NAME="$(NAME)"; \
	if ls m-drawable/*/$(NAME).png >/dev/null 2>&1; then \
		echo "⚠️  Files with name '$(NAME).png' already exist in m-drawable folders."; \
		echo "Do you want to create a new version? (y/N)"; \
		read -r CONFIRM; \
		if [ "$$CONFIRM" = "y" ] || [ "$$CONFIRM" = "Y" ]; then \
			VERSION=1; \
			while ls m-drawable/*/$(NAME)_v$$VERSION.png >/dev/null 2>&1; do \
				VERSION=$$((VERSION + 1)); \
			done; \
			FINAL_NAME="$(NAME)_v$$VERSION"; \
			echo "Creating new version: $$FINAL_NAME.png"; \
		else \
			echo "Operation cancelled."; \
			exit 0; \
		fi; \
	fi; \
	echo "Generating icons with name: $$FINAL_NAME.png"; \
	echo "Generating ldpi (25% of original)..."; \
	magick "$(SOURCE)" -scale 25% "m-drawable/drawable-ldpi/$$FINAL_NAME.png"; \
	echo "Generating mdpi (50% - original size)..."; \
	magick "$(SOURCE)" -scale 50% "m-drawable/drawable-mdpi/$$FINAL_NAME.png"; \
	echo "Generating hdpi (75% of original)..."; \
	magick "$(SOURCE)" -scale 75% "m-drawable/drawable-hdpi/$$FINAL_NAME.png"; \
	echo "Generating xhdpi (100% of original)..."; \
	magick "$(SOURCE)" -scale 100% "m-drawable/drawable-xhdpi/$$FINAL_NAME.png"; \
	echo "Generating xxhdpi (200% of original)..."; \
	magick "$(SOURCE)" -scale 200% "m-drawable/drawable-xxhdpi/$$FINAL_NAME.png"; \
	echo "Generating xxxhdpi (300% of original)..."; \
	magick "$(SOURCE)" -scale 300% "m-drawable/drawable-xxxhdpi/$$FINAL_NAME.png"; \
	echo ""; \
	echo "✅ Successfully generated icons for all Android densities!"; \
	echo "Files created (scaled from source image):"; \
	echo "  • drawable-ldpi/$$FINAL_NAME.png (25%)"; \
	echo "  • drawable-mdpi/$$FINAL_NAME.png (50%)"; \
	echo "  • drawable-hdpi/$$FINAL_NAME.png (75%)"; \
	echo "  • drawable-xhdpi/$$FINAL_NAME.png (100%  - original)"; \
	echo "  • drawable-xxhdpi/$$FINAL_NAME.png (200%)"; \
	echo "  • drawable-xxxhdpi/$$FINAL_NAME.png (300%)"

clean-icons:
	@echo "Cleaning generated icons..."
	@find m-drawable/ -name "$(NAME).png" -delete
	@find m-drawable/ -name "$(NAME)_v*.png" -delete
	@echo "✅ Cleaned all generated icons for $(NAME)"

help:
	@echo "Android Drawable Icon Generator"
	@echo ""
	@echo "Commands:"
	@echo "  generate-icon    Generate Android drawable icons from source image (.png only)"
	@echo "  clean-icons      Remove all generated icons"
	@echo "  help            Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  SOURCE          Source image file (default: icon.png)"
	@echo "  NAME            Output filename without extension (default: ic_launcher)"
	@echo ""
	@echo "Examples:"
	@echo "  make generate-icon SOURCE=my_icon.png"
	@echo "  make generate-icon SOURCE=logo.png NAME=ic_logo"
	@echo "  make clean-icons NAME=ic_logo"
	@echo ""
	@echo "Note: Only .png files are supported for output."
	@echo "Scaling ratios based on Android density guidelines:"
	@echo "  • ldpi: 75% of source image"
	@echo "  • mdpi: 100% of source image (original size)"
	@echo "  • hdpi: 150% of source image"
	@echo "  • xhdpi: 200% of source image"
	@echo "  • xxhdpi: 300% of source image"
	@echo "  • xxxhdpi: 400% of source image"
	@echo "If files with the same NAME already exist, you'll be prompted to create a versioned copy."

.PHONY: generate-icon clean-icons help