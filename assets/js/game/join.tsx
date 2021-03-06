import React, {FormEvent, useState} from "react"
import {Channel} from "phoenix"
import {useAuthToken} from "./useAuthToken"

interface JoinProps {
    channel: Channel
    joined: boolean
}

export const Join = ({channel, joined}: JoinProps) => {
    const [name, setName] = useState("")
    const {authToken} = useAuthToken()

    const join = (event: FormEvent) => {
        event.preventDefault()
        channel.push("join_play", {name: name})
    }

    if (joined) return (
        <section className="narrow text-center">
            <p>Waiting for opponent to join the game.</p>
        </section>
    )

    return (
        <section className="narrow">
            <form onSubmit={join}>
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
