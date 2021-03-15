module ISX.CE.API.Init (
    initAPI,
    routesAPI,
    ) where


import           ISX.CE.API.Types
import           Snap.Core
import           Snap.Snaplet
import           TPX.Com.Snap.CoreUtils
import qualified ISX.CE.API.Zone.Apex     as ZA
import qualified ISX.CE.API.Zone.PlugProc as ZPP
import qualified ISX.CE.API.Zone.Site     as ZS
import qualified TPX.Com.SQLite.Conn      as D


initAPI :: D.Conn -> SnapletInit b API
initAPI d = makeSnaplet "API" "" Nothing $ do
    addRoutes routesAPI
    return $ API d

routesAPI :: [(ByteString, Handler b API ())]
routesAPI = [
    ("",                                    ifTop           ZA.apex),
    --
    ("plug_proc",                           method GET      ZPP.list),
    ("plug_proc",                           method POST     ZPP.create),
    ("plug_proc/:_",                                        notFound),
    ("plug_proc/:plug_proc_id",             method DELETE   ZPP.delete),
    ("plug_proc/:plug_proc_id",             method GET      ZPP.read),
    ("plug_proc/:plug_proc_id/:_",                          notFound),
    ("site",                                method POST     ZS.create),
    ("site/:_",                                             notFound),
    ("site/:site_id",                       method GET      ZS.read),
    ("site/:site_id/:_",                                    notFound),
    --
    ("",                                                    notFound)]
