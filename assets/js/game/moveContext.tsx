import React, {createContext, Dispatch, ReactNode, useReducer} from 'react'
import {TGood, TShop} from "./shop"
import {TWallet} from "./player"
import {TKind} from "./unit"

type TMoveContext = {
    shop: TShop
    selectedGood: TGood | null
    wallet: TWallet
    moves: Array<TMove>
}

type TMove = {
    type: "place_unit",
    unit: { kind: TKind, level: number },
    position: { column: number, row: number }
}

type TAction = { type: "updateShop", payload: TShop }
    | { type: "selectGood", payload: TGood }
    | { type: "updateWallet", payload: TWallet }
    | { type: "placeUnit", payload: { column: number, row: number } }
    | { type: "roundEnd" }

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
        case "placeUnit": {
            return placeUnit(state, action.payload)
        }
        case "roundEnd": {
            return {...state, moves: []}
        }
        default: {
            return state
        }
    }
}

const placeUnit = (state: TMoveContext, payload: { column: number, row: number }): TMoveContext => {
    if (!state.selectedGood) return state

    const alreadyPlaced = state.moves.find(move => {
        if (move.type !== "place_unit") return false
        return move.position.column === payload.column && move.position.row === payload.row
    })
    if (alreadyPlaced) return state

    const goodIdx = state.shop.goods.findIndex(x => x === state.selectedGood)
    if (goodIdx === -1) return state

    if (state.wallet.money - state.selectedGood.price.money < 0) return state
    if (state.wallet.mana - state.selectedGood.price.mana < 0) return state
    state.wallet.money -= state.selectedGood.price.money
    state.wallet.mana -= state.selectedGood.price.mana

    if (state.selectedGood.count > 1) {
        state.selectedGood.count -= 1
        state.shop.goods[goodIdx] = state.selectedGood
    } else {
        state.shop.goods.splice(goodIdx, 1)
    }

    state.moves = [...state.moves, {
        type: "place_unit",
        unit: {kind: state.selectedGood.kind, level: state.selectedGood.level},
        position: {column: payload.column, row: payload.row}
    }]

    return {...state}
}

export const MoveContext = createContext<TReducer>([initial, () => null])

export const MoveContextProvider = ({children}: { children: ReactNode }) => (
    <MoveContext.Provider value={useReducer(reducer, initial)}>
        {children}
    </MoveContext.Provider>
)
