import React, {useContext, useEffect} from "react"
import styles from "./shop.module.scss"
import {TKind, Unit} from "./unit"
import {MoveContext} from "./moveContext"

interface ShopProps {
    shop: TShop
}

export type TShop = {
    goods: Array<TGood>
}

export type TGood = {
    kind: TKind
    level: number
    count: number
    price: {
        money: number
        mana: number
    }
}

export const Shop = ({shop}: ShopProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    useEffect(() => {
        dispatch({type: "updateShop", payload: shop})
    }, [shop])

    return (<section className={styles.shop}>
            <div className={styles.wrapper}>
                {ctx.shop.goods.map(good => (
                    <div key={`${good.kind}-${good.level}`}
                         className={`${styles.shopUnit}
                                     ${ctx.selectedGood === good && styles.selected}
                                     ${ctx.wallet.money - good.price.money <= 0 && styles.tooExpensive}
                                     ${ctx.wallet.mana - good.price.mana <= 0 && styles.tooExpensive}`}
                         onClick={() => dispatch({type: "selectGood", payload: good})}
                    >
                        <Unit unit={good}/>
                        <div className="swell-around">
                            <span className={styles.countBadge}>{good.count}</span>
                            <span className={styles.moneyBadge}>{good.price.money}</span>
                            {good.price.mana ? <span className={styles.manaBadge}>{good.price.mana}</span> : <></>}
                        </div>
                    </div>
                ))}
            </div>
        </section>
    )
}
