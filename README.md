# MirrorTakeHome

A few things:
1. I took this opportunity to learn Swift, but don't know the ins and outs of the language, so there may be some bad practices. I tried my best to update the worse style as I learned, but there may be some inconsistencies between the code I started with and what I ended with.
2. I created some views in Storyboard that I ended up not using. Everything should be programmatic.
3. Things I wish I included but didn't have time
- Unit tests :( I don't know how to write unit tests. Happy to learn! But it would've taken me too long to learn and implement well I think. I did try to design everything to be easily testable however.
- Serializing/deserializing with Codable
- Robust error handling
- Loading spinner
4. The prompt had a couple small typos. In hindsight, I should've asked for help instead of wringing my hands trying to figure out why things weren't working as expected.
- The PATCH edit data endpoint is listed as "/users/me" instead of "/user/me". This one was okay because the API in swagger was clear.
- The "user/me" endpoint Authorization header is listed as 
      Header: “Authorization” “Bearer: <jwt token>"
  but should be 
      Header: “Authorization” “Bearer <jwt token>”
  without the extra colon. This one took a while because I'm not familiar with jwt tokens.


