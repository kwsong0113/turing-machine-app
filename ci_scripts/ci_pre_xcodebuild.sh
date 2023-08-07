#!/bin/sh

cd ../TuringMachine

touch Secret.plist

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"\>
<plist version=\"1.0\">
<dict/>
</plist>" >> Secret.plist

plutil -replace WEBSOCKET_ENDPOINT_URL -string $WEBSOCKET_ENDPOINT_URL Secret.plist
plutil -replace API_ENDPOINT_URL -string $API_ENDPOINT_URL Secret.plist

exit 0
