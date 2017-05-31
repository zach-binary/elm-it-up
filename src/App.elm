module App exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


---- MODEL ----


type alias BrokerageAccount =
    { accountNumber: Int 
    , accountTitle: String
    , accountType: String
    }

type BankAccountStatus = Pending | Approved
type alias BankAccount = 
    { bankName: String
    , accountName: String
    , accountNumber: Int 
    , status: BankAccountStatus
    }

type alias Model =
    { brokerageAccounts: List BrokerageAccount
    , bankAccounts: List BankAccount
    , showBrokerageOptions: Bool
    , showBankingOptions: Bool
    }


brokerageAccounts: List BrokerageAccount 
brokerageAccounts =
    [
        { accountNumber = 156487498
        , accountType = "Equities"
        , accountTitle = "Zach" }
    ]

bankAccounts: List BankAccount
bankAccounts =
    [
        { bankName = "Bank Of America" 
        , accountName = "Checkings" 
        , accountNumber = 1234
        , status = Pending }
    ]

init : String -> ( Model, Cmd Msg )
init path =
    ( 
        { brokerageAccounts = brokerageAccounts
        , bankAccounts = bankAccounts
        , showBrokerageOptions = False
        , showBankingOptions = False
        }, Cmd.none 
    )

---- UPDATE ----


type Msg = ShowBrokerageOptions Bool
    | ShowBankingOptions Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        ShowBrokerageOptions toggle -> 
            ({ model | showBrokerageOptions = toggle }, Cmd.none)

        ShowBankingOptions toggle -> 
            ({ model | showBankingOptions = toggle }, Cmd.none)

---- VIEW ----


view : Model -> Html Msg
view model = 
    div [ class "main" ]
        [ h1 [] 
          [ ripOffOwnSelf "manageBankAccounts.png" --i [ class "fa fa-usd" ] []
          , span [] [ text "Move Money" ]
          ]
        , hr [] []
        , p  [] [ text "Select an account to move money into" ]
        , h2 [] [ text "Brokerage Accounts" ]
        , ul [ class "account-list" ] (List.map brokerageListItem model.brokerageAccounts)
        , h2 [] [ text "Bank Accounts" ]
        , ul [ class "account-list" ] (bankList model.bankAccounts)
        , h2 [] [ text "Request History" ]
        , requestHistory
        , depositOptionsModal model
        ]
        
brokerageListItem : BrokerageAccount -> Html Msg
brokerageListItem account =
    li [ onClick (ShowBrokerageOptions True) ] 
       [ div [ class "account" ] 
         [ div [] 
           [ strong [] [ text (account.accountType) ]
           ]
         , span [] [ text (account.accountTitle ++ " - ") ]
         , span [] [ text (toString account.accountNumber) ]
         ]
       , div [ class "actions" ]
           [ i [ class "fa fa-chevron-right" ] [] ]
    ]

bankList: List BankAccount -> List (Html Msg)
bankList bankAccounts =
    List.append (List.map bankListItem bankAccounts)
        [li [] 
         [ div [ class "account" ] 
           [ span [] [ text "Add a Bank Account" ]
           ]
         , div [ class "actions" ] 
           [ i [ class "fa fa-plus" ] []
           ]
         ]]

bankListItem : BankAccount -> Html Msg
bankListItem account =
     li [ onClick (ShowBankingOptions True) ] 
       [ div [ class "account" ] 
         [ div [] 
           [ strong [] [ text (account.bankName) ]
           ]
         , span [] [ text (account.accountName ++ " - ") ]
         , span [] [ text (toString account.accountNumber ++ " - ") ]
         , i [] [ text (toString account.status)]
         ]
       , div [ class "actions" ]
           [ i [ class "fa fa-chevron-right" ] [] ]
    ]

requestHistory : Html Msg
requestHistory =
    div [ class "request-history" ]
    [ span [] [ text "View Request History" ]
    , i [ class "fa fa-chevron-right" ] []
    ]

depositOptionsModal : Model -> Html Msg
depositOptionsModal model =
    if model.showBrokerageOptions then 
        modalWrapper 
        (div [ class "deposit-options-modal" ]
             [ h3 [] [ text "Where would you like to transfer from?" ]
             , ul [] 
                [ li [] [ option "Bank via ACH Transfer (Preferred)" 
                            "ach.png" 
                            "3 to 5 Business Days" ]
                , li [] [ option "Another Tradestation Account" 
                            "internal.png" 
                            "Next Day (If placed before 12 p.m. ET today)" ]
                , li [] [ option "Bank via Check Transfer" 
                            "checks.png" 
                            "Up to 3 Business Days" ]
                , li [] [ option "Bank via Wire Transfer" 
                            "wireTransfer.png" 
                            "Next Business Day (if received before 4 p.m. ET today)" ]
                , li [ onClick (ShowBrokerageOptions False) ] 
                  [ a [ class "dismiss", href "#" ] [ text "Dismiss" ] ]
                ]
             ])
    else (div [] [])

option : String -> String -> String -> Html msg
option labelText imgName description =
    div [ class "deposit-option" ] 
    [ ripOffOwnSelf imgName 
    , div [] 
      [ strong [ ] [ text labelText ]
      , div [ class "description" ] [ text description ]
      ]
    ]

modalWrapper : Html Msg -> Html Msg
modalWrapper modal =
    div [ class "modal-wrapper" ] [ modal ]

ripOffOwnSelf : String -> Html msg
ripOffOwnSelf imageName =
    img [ src ("https://elmitup.blob.core.windows.net/movemoney/images/" ++ imageName) ] []

---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
