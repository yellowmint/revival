import React, {FormEvent, useState} from "react"
import {Channel} from "phoenix"
import {useAuthToken} from "./useAuthToken"

interface JoinProps {
    channel: Channel
    players: Array<TPlayer>
}

export type TPlayer = {
    id: string
    anonymous: boolean
    name: string
    rank: number
}

export const Join = ({channel, players}: JoinProps) => {
    const [name, setName] = useState("")
    const [error, setError] = useState("")
    const [playerId, setPlayerId] = useState("")
    const {authToken} = useAuthToken()

    const join = (event: FormEvent) => {
        event.preventDefault()

        channel.push("join_game", {name: name})
            .receive("ok", resp => setPlayerId(resp.player_id))
            .receive("error", () => setError("Cannot join game"))
    }

    if (playerId || players.length >= 2) return <></>

    return (
        <section>
            <form onSubmit={join}>
                {error && <div className="alert alert-warning">{error}</div>}
                {!authToken && <label>
                    Name
                    <input value={name}
                           onChange={({target}) => setName(target.value)}
                           type="text"
                           required={true}
                    />
                </label>}
                <button type="submit" className="button">Join</button>
            </form>
        </section>
    )
}
