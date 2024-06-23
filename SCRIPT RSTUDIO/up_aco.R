# Parameter ACO
n_ants <- 50        # Jumlah semut
n_iterations <- 100 # Jumlah iterasi
alpha <- 1          # Pengaruh pheromone
beta <- 2           # Pengaruh jarak
rho <- 0.5          # Tingkat penguapan pheromone
q <- 100            # Jumlah pheromone yang dilepaskan semut per unit panjang
tau <- matrix(1, nrow = 9, ncol = 9) # Matriks pheromone awal

# Fungsi untuk menghitung probabilitas transisi
transition_probability <- function(tau, eta, alpha, beta) {
  prob <- (tau^alpha) * (eta^beta)
  prob / sum(prob)
}

# Fungsi untuk menghitung jarak rute
route_distance <- function(route, d) {
  dist <- 0
  for (i in 1:(length(route) - 1)) {
    dist <- dist + d[route[i], route[i + 1]]
  }
  dist <- dist + d[route[length(route)], route[1]] # kembali ke kota awal
  dist
}

# Fungsi untuk update pheromone
update_pheromone <- function(tau, routes, distances, rho, q) {
  delta_tau <- matrix(0, nrow = nrow(tau), ncol = ncol(tau))
  for (k in 1:length(routes)) {
    route <- routes[[k]]
    distance <- distances[k]
    for (i in 1:(length(route) - 1)) {
      delta_tau[route[i], route[i + 1]] <- delta_tau[route[i], route[i + 1]] + q / distance
      delta_tau[route[i + 1], route[i]] <- delta_tau[route[i + 1], route[i]] + q / distance
    }
    delta_tau[route[length(route)], route[1]] <- delta_tau[route[length(route)], route[1]] + q / distance
    delta_tau[route[1], route[length(route)]] <- delta_tau[route[1], route[length(route)]] + q / distance
  }
  tau <- (1 - rho) * tau + delta_tau
  tau
}

# Inisialisasi variabel terbaik
best_route <- NULL
best_distance <- Inf

# Algoritma ACO
for (iter in 1:n_iterations) {
  routes <- list()
  distances <- numeric(n_ants)
  
  for (k in 1:n_ants) {
    route <- numeric(9)
    route[1] <- sample(1:9, 1) # Kota awal
    for (i in 2:9) {
      current_city <- route[i - 1]
      remaining_cities <- setdiff(1:9, route[1:(i - 1)])
      eta <- 1 / d[current_city, remaining_cities]
      prob <- transition_probability(tau[current_city, remaining_cities], eta, alpha, beta)
      next_city <- sample(remaining_cities, 1, prob = prob)
      route[i] <- next_city
    }
    routes[[k]] <- route
    distances[k] <- route_distance(route, d)
    
    # Update solusi terbaik
    if (distances[k] < best_distance) {
      best_distance <- distances[k]
      best_route <- route
    }
  }
  
  # Update pheromone
  tau <- update_pheromone(tau, routes, distances, rho, q)
  
  cat("Iterasi:", iter, "- Jarak Terbaik:", best_distance, "\n")
}

# Hasil akhir
cat("Rute Terbaik: ", best_route, "\n")
cat("Jarak Terbaik: ", best_distance, "\n")