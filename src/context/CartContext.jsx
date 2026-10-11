import { createContext, useContext, useEffect, useState } from "react";
import { api } from "../api";
import { useAuth } from "./AuthContext";

const CartContext = createContext(null)

export function CartProvider({children}){
    const {user} = useAuth()
    const [cart, setCart] = useState([])
    const [loading, setLoading] = useState(false)

    async function reload() {
        if (!user) {setCart([]); return}
        setLoading(true)
        try {setCart(await api.cart(user.id))}
        catch{setCart([])}
        finally {setLoading(false)}
    }

    useEffect(() => {reload()}, [user?.id])

    async function addToCart(service) {
        if (!user) return
        await api.addToCart(user.id, service.id, 1)
        reload()
    }

    async function updateQuantity(cartItemId, quantity) {
        if (quantity <= 0) return removeFromCart(cartItemId)
        await api.updateCartItem(cartItemId, quantity)
        reload()
    }

    async function removeFromCart(cartItemId) {
        await api.removeCartItem(cartItemId)
        reload()
    }

    async function clearCart() {
        if (!user) return
        await api.clearCart(user.id)
        reload()
    }

    return(
        <CartContext.Provider value={{
            cart,
            loading,
            totalCount: cart.reduce((sum, item) => sum + item.quantity, 0),
            addToCart,
            updateQuantity,
            removeFromCart,
            clearCart,
            reload,
        }}>
            {children}
        </CartContext.Provider>
    )
}

export const useCart = () => useContext(CartContext)