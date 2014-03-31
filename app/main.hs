import Prelude              (IO, ($), (>>=), (.), print)

import TLSSocket

import Yesod.Default.Config -- (fromArgs)
import Yesod.Default.Main   (defaultMain)
import Settings             (parseExtra)
import Application          (makeApplication)

-- import Network.Wai.Handler.WarpTLS
import Network.Wai.Handler.Warp
import Data.Conduit.Network
import Network
import Control.Exception
import System.Posix

-- tlss = tlsSettings
crt = "/home/tatsuya/csr/2014crt_cross_owl_skami3.pem"
key = "/home/tatsuya/csr/mydomain.key"

main :: IO ()
main = do -- defaultMain (fromArgs parseExtra) makeApplication
	config <- load
	(app, _) <- getApp config
	bracket (bindPort (appPort config) (appHost config)) sClose $ \socket -> do
		getGroupEntryForName "yesod" >>= setGroupID . groupID
		getUserEntryForName "yesod" >>= setUserID . userID
		runTLSSocket crt key defaultSettings {
			settingsPort = appPort config,
			settingsHost = appHost config
		 } socket app
	where
	load = fromArgs parseExtra
	getApp = makeApplication
