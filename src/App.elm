module App exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


---- MODEL ----

type Page = MoveMoney 
    | RequestHistory 
    | BrokerageOptions 
    | BankOptions
    | ChooseBank

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
    , page: Page
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
        , page = MoveMoney
        }, Cmd.none 
    )

---- UPDATE ----

type Msg = ShowBrokerageOptions Bool
    | ShowBankingOptions Bool
    | ChangePage Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        ShowBrokerageOptions toggle -> 
            ({ model | showBrokerageOptions = toggle }, Cmd.none)

        ShowBankingOptions toggle -> 
            ({ model | showBankingOptions = toggle }, Cmd.none)

        ChangePage page ->
            ({ model | page = page }, Cmd.none)


---- VIEW ----


view : Model -> Html Msg
view model = 
    case model.page of
        MoveMoney -> moveMoney model
        BrokerageOptions -> brokerageOptions model
        RequestHistory -> requestHistory model
        BankOptions -> bankOptions model
        ChooseBank -> chooseBank model

moveMoney : Model -> Html Msg
moveMoney model =
    div [ class "main" ]
        [ h1 [] 
          [ span [] [ text "Move Money" ]
          ]
        , hr [] []
        , p  [] [ text "Select an account to move money into" ]
        , h2 [] [ text "Brokerage Accounts" ]
        , ul [ class "account-list" ] (List.map brokerageListItem model.brokerageAccounts)
        , h2 [] 
            [ text "Bank Accounts" 
            , span [ onClick (ChangePage BankOptions) ] [
                i [ class "fa fa-cog" ] [] 
            ]
            ]
        , ul [ class "account-list" ] (bankList model.bankAccounts)
        , h2 [] [ text "Request History" ]
        , requestHistoryListItem
        ]
        
brokerageListItem : BrokerageAccount -> Html Msg
brokerageListItem account =
    li [ onClick (ChangePage BrokerageOptions) ] 
       [ div [ class "options" ] 
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
         [ div [ class "options" ] 
           [ span [] [ text "Add a Bank Account" ]
           ]
         , div [ class "actions" ] 
           [ i [ class "fa fa-plus" ] []
           ]
         ]]

bankListItem : BankAccount -> Html Msg
bankListItem account =
     li [ onClick (ShowBankingOptions True) ] 
       [ div [ class "options" ] 
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

requestHistoryListItem : Html Msg
requestHistoryListItem =
    div [ onClick (ChangePage RequestHistory)
        , class "other-options" 
        ]
    [ span []
        [ text "View Request History" ]
    , i [ class "fa fa-chevron-right" ] []
    ]

return : Page -> Html Msg
return page =
    span [ onClick (ChangePage page) ]
        [ i [ class "fa fa-chevron-left" ] []
        , text "Back" ]

brokerageOptions : Model -> Html Msg
brokerageOptions model =
    div [ class "brokerage-options" ]
        [ h2 [] [ return MoveMoney ]
        , h3 [] [ text "How would you like to move money?" ]
        , ul [] 
            [ li [ onClick (ChangePage ChooseBank) ]
                 [ transferOption "Bank via ACH Transfer (Preferred)" 
                        "ach.png" 
                        "3 to 5 Business Days"
                    , i [ class "fa fa-chevron-right" ] [] ]
            , li [] [ transferOption "Another Tradestation Account" 
                        "internal.png" 
                        "Next Day (If placed before 12 p.m. ET today)"
                    , i [ class "fa fa-chevron-right" ] [] ]                        
            , li [] [ transferOption "Bank via Check Transfer" 
                        "checks.png" 
                        "Up to 3 Business Days"
                    , i [ class "fa fa-chevron-right" ] [] ]                        
            , li [] [ transferOption "Bank via Wire Transfer" 
                        "wireTransfer.png" 
                        "Next Business Day (if received before 4 p.m. ET today)"
                    , i [ class "fa fa-chevron-right" ] [] ]                        
            ]
        ]

requestHistory : Model -> Html Msg
requestHistory model =
    div [ class "request-history" ]
        [ h2 [] [ return MoveMoney ]
        , ul []
        [ li [] [ text "Item 1" ]
        , li [] [ text "Item 2" ]
        ]
        ]

bankOptions : Model -> Html Msg
bankOptions model =
    div [ class "bank-options" ]
        [ h2 [] [ return MoveMoney ]
        , ul [ class "account-list" ] (bankList model.bankAccounts)
        ]

chooseBank : Model -> Html Msg
chooseBank model =
    div [ class "bank-options" ]
        [ h2 [] [ return BrokerageOptions ]
        , h3 [] [ text "Select an account to move money from" ]
        , ul [ class "account-list" ] (bankList model.bankAccounts)
        ]

achTransfer : Model -> Html Msg
achTransfer model =
    div [ class "ach-transfer" ]
        [ h2 [] [ return ChooseBank ]
        , h3 [] [ text "Enter an amount to transfer" ]
        ]

transferOption : String -> String -> String -> Html msg
transferOption labelText imgName description =
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
