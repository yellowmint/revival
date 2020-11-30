import React, {FormEvent, useState} from "react"
import {Channel} from "phoenix"
import {useAuthToken} from "./useAuthToken"

interface JoinProps {
    channel: Channel
    playersCount: number
    playerId: string
    setPlayerId: React.Dispatch<React.SetStateAction<string>>
}

export const Join = ({channel, playersCount, playerId, setPlayerId}: JoinProps) => {
    const [name, setName] = useState("")
    const [error, setError] = useState("")
    const {authToken} = useAuthToken()

    const join = (event: FormEvent) => {
        event.preventDefault()

        channel.push("join_game", {name: name})
            .receive("ok", resp => setPlayerId(resp))
            .receive("error", () => setError("Cannot join game"))
    }

    if (playerId || playersCount >= 2) return <></>

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
