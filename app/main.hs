import Prelude              (IO, ($), (.), fst, String)
import Control.Applicative  ((<$>))
import Control.Exception    (bracket)

import Yesod.Default.Config -- (fromArgs)
import Yesod.Default.Main   (defaultMain)
import Settings             (parseExtra)
import Application          (makeApplication)

import Network
import Network.Wai.Handler.WarpTLS.UID (runTLSSocketWithID, tlsSettings)
import Network.Wai.Handler.Warp
import Data.Conduit.Network

crt, key :: String
crt = "/home/tatsuya/csr/2014crt_cross_owl_skami3.pem"
key = "/home/tatsuya/csr/mydomain.key"

tlss = tlsSettings crt key

main :: IO ()
main = do -- defaultMain (fromArgs parseExtra) $ (fst <$>) . makeApplication
	config <- fromArgs parseExtra
	(app, _) <- makeApplication config
	bracket (bindPort (appPort config) (appHost config)) sClose $ \sock -> do
		runTLSSocketWithID tlss defaultSettings {
			settingsPort = appPort config,
			settingsHost = appHost config
		 } sock ("yesod", "yesod") app
