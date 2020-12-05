import React, {createContext, Dispatch, ReactNode, useReducer} from 'react'
import {TGood, TShop} from "./shop"
import {TWallet} from "./player"

type TMoveContext = {
    shop: TShop
    selectedGood: TGood | null
    wallet: TWallet
    moves: Array<object>
}

type TAction = { type: "updateShop", payload: TShop }
    | { type: "selectGood", payload: TGood }
    | { type: "updateWallet", payload: TWallet }

const initial = {
    shop: {
        goods: []
    },
    selectedGood: null,
    wallet: {
        money: 0,
        mana: 0
    },
    moves: []
}

type TReducer = [TMoveContext, Dispatch<TAction>]

const reducer = (state: TMoveContext, action: TAction): TMoveContext => {
    switch (action.type) {
        case "updateShop": {
            return {...state, shop: action.payload}
        }
        case "selectGood": {
            return {...state, selectedGood: action.payload}
        }
        case "updateWallet": {
            return {...state, wallet: action.payload}
        }
        default: {
            return state
        }
    }
}

export const MoveContext = createContext<TReducer>([initial, () => null])

export const MoveContextProvider = ({children}: { children: ReactNode }) => (
    <MoveContext.Provider value={useReducer(reducer, initial)}>
        {children}
    </MoveContext.Provider>
)
