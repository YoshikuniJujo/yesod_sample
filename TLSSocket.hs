module TLSSocket (runTLSSocket) where

import Prelude (FilePath, IO)

import Params (makeParams)
import Getter (getter)

-- import Control.Applicative
import qualified Data.ByteString as B
import Network.Socket (Socket)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (Settings, runSettingsConnection)

runTLSSocket ::
	B.ByteString -> B.ByteString -> Settings -> Socket -> Application -> IO ()
runTLSSocket crt key set sock =
	runSettingsConnection set (getter (makeParams crt key) sock)
